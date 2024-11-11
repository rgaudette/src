// Counting Words Across Files My Style.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

using namespace std;

using WordOccurences = unordered_map<string, size_t>;

WordOccurences word_occurences_in_file(const char * const file_name)
{
  ifstream file(file_name);
  WordOccurences word_occurences;
  for (string word; file >> word;)
  {
    ++word_occurences[word];
  }
  return word_occurences;
}


template<typename MapIterator>
void show_common_words(MapIterator begin, MapIterator end, const size_t n)
{
  vector<MapIterator> wordIters;
  wordIters.reserve(distance(begin, end));

  for (auto i = begin; i != end; ++i)
  {
    wordIters.push_back(i);
  }

  auto sortedRangeEnd = wordIters.begin() + n;
  partial_sort(wordIters.begin(),
               sortedRangeEnd,
               wordIters.end(),
               [](MapIterator it1, MapIterator it2)
  {
    return (it1->second > it2->second);
  });

  for (auto it = wordIters.cbegin(); it != sortedRangeEnd; ++it)
  {
    printf("  %-10s%10zu\n", (*it)->first.c_str(), (*it)->second);
  }
}


// take list of file names on command line, print 20 most common words within; process files concurrently
int main(int argc, const char ** argv)
{
  // Count the occurrences of each word in each file specified on the command line using a separate thread for each
  // file processed
  vector<future<WordOccurences>> futures;
  for (int idx_arg = 1; idx_arg < argc; ++idx_arg)
  {
    futures.push_back(async([ = ] { return word_occurences_in_file(argv[idx_arg]); }));
  }

  WordOccurences total_word_occurences;
  for (auto & f : futures)
  {
    const auto word_occurences_for_file = f.get();    // move map returned by wordsInFile
    for (const auto & word_occurence : word_occurences_for_file)
    {
      total_word_occurences[word_occurence.first] += word_occurence.second;
    }
  }

  cout << total_word_occurences.size() << " words found.  Most common:\n";
  const size_t maxWordsToShow = 20;
  show_common_words(total_word_occurences.begin(), total_word_occurences.end(), min(total_word_occurences.size(), maxWordsToShow));
}
