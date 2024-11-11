
#include "stdafx.h"

using namespace std;
using namespace boost::filesystem;


// Given a directory return a pair of vectors containing the directories and files in the directory
pair<vector<path>, vector<path>> list_directory(const string directory)
{
  vector<path> sub_directories;
  vector<path> files;

  path dir(directory);

  try
  {
    auto di = directory_iterator(dir);
    auto dend = directory_iterator();
    while (di != dend)
    {
      path entry = *di;
      if (is_regular_file(entry))
      {
        files.push_back(entry);
      }
      else if (is_directory(entry))
      {
        sub_directories.push_back(entry);
      }
      else
      {
        cout << "Unknown entry type: " << entry << endl;
      }
      ++di;
    }
  }
  catch (const filesystem_error & ex)
  {
    cout << ex.what() << '\n';
  }

  auto p = make_pair(sub_directories, files);
  return p;
}

// Recursively list all of the files in the given path
vector<path> list_all_files_in_tree(path directory)
{
  auto dir_file_pair = list_directory(directory.string());

  vector<path> files;
  files.insert(files.end(), dir_file_pair.second.begin(), dir_file_pair.second.end());

  for (path & s : dir_file_pair.first)
  {
    auto sub_dir_files = list_all_files_in_tree(s.string());
    files.insert(files.end(), sub_dir_files.begin(), sub_dir_files.end());
  }

  return files;
}


// Return the current performance timer reading
LARGE_INTEGER get_performance_timer_time()
{
  LARGE_INTEGER start;
  BOOL ret_val = QueryPerformanceCounter(&start);

  if (ret_val == 0)
  {
    cerr << "Unable to query performance counter timer" << endl;
  }
  return start;
};


double get_performance_timer_elapsed_seconds(LARGE_INTEGER start)
{
  LARGE_INTEGER stop;
  BOOL ret_val = QueryPerformanceCounter(&stop);

  if (ret_val == 0)
  {
    cerr << "Unable to query performance counter timer" << endl;
  }

  LONGLONG  elapsed_counts = stop.QuadPart - start.QuadPart;

  LARGE_INTEGER frequency;
  ret_val = QueryPerformanceFrequency(&frequency);
  if (ret_val == 0)
  {
    cerr << "Unable to query performance counter frequency" << endl;
  }

  double elapsed_secs = static_cast<double>(elapsed_counts) / frequency.QuadPart;
  return elapsed_secs;
};


int main(int argc, char * argv[])
{

  LARGE_INTEGER start = get_performance_timer_time();

  // First list the files and subdirectories of the command line argument
  auto p = list_directory(argv[1]);
  auto & all_files = p.second;

  // Sequential search of each sub directory
  //for (path & dir : p.first)
  //{
  //  auto files = list_all_files_in_tree(dir);
  //  all_files.insert(all_files.end(), files.begin(), files.end());
  //}

  // Asynchronous search of each sub directory
  vector<future<vector<path>>> subdir_futures;
  for (path & dir : p.first)
  {
    subdir_futures.push_back(async([ = ] { return list_all_files_in_tree(dir); }));
  }

  for (auto & sub_dir_future : subdir_futures)
  {
    const auto files = sub_dir_future.get();
    all_files.insert(all_files.end(), files.begin(), files.end());
  }

  double elapsed_time = get_performance_timer_elapsed_seconds(start);

  //cout << "Files:" << endl;
  //for (auto file : all_files)
  //{
  //  cout << file << endl;
  //}
  cout << all_files.size() << " files found in " << elapsed_time << " seconds." << endl;

  return 0;
}

