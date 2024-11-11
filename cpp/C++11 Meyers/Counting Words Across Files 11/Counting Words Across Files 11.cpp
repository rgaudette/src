// Counting Words Across Files 11.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

// RJG: using can now be used the same as typedef with a slightly different syntax, the unordered map is probably more
// efficient for this case hence why Meyers chose it
using WordCountMapType = std::unordered_map<std::string, std::size_t>;
//typedef std::map<std::string, std::size_t> WordCountMapType;

WordCountMapType wordsInFile(const char * const fileName)    // for each word
{
  // in file, return
  std::ifstream file(fileName); // # of
  WordCountMapType wordCounts; // occurrences
  for (std::string word; file >> word;)
  {
    ++wordCounts[word];
  }
  return wordCounts;
}

// print n most common words in [begin, end)
template<typename MapIt>
void showCommonWords(MapIt begin, MapIt end, const std::size_t n)
{
  // QUESTION: why get rid of the two typedefs in the 98 version and explicitly use a vector
  // because we can use auto in the definition of sortedRangeEnd and the last for loop, the code is easier to read

  std::vector<MapIt> wordIters;
  wordIters.reserve(std::distance(begin, end));

  for (auto i = begin; i != end; ++i)
    wordIters.push_back(i);

  auto sortedRangeEnd = wordIters.begin() + n;
  // RJG: use a C++11 lambda instead of the Ptr2Pair2ndGT class
  std::partial_sort(wordIters.begin(),
                    sortedRangeEnd,
                    wordIters.end(),
                    [](MapIt it1, MapIt it2)
  {
    return it1->second > it2->second;
  });

  for (auto it = wordIters.cbegin(); it != sortedRangeEnd; ++it)
  {
    std::printf("  %-10s%10zu\n", (*it)->first.c_str(), (*it)->second);
  }
}

// take list of file names on command line, print 20 most common words within; process files concurrently
int main(int argc, const char ** argv)
{
  // RJG: create a vector of futures that return the WordCountMapType
  std::vector<std::future<WordCountMapType>> futures;
  for (int argNum = 1; argNum < argc; ++argNum)
  {
    // Spin off thread to count the words in each file

    futures.push_back(std::async([ = ] { return wordsInFile(argv[argNum]); }));
  }

  WordCountMapType wordCounts;
  for (auto & f : futures)
  {
    const auto wordCountInfoForFile = f.get();    // move map returned by wordsInFile
    for (const auto & wordInfo : wordCountInfoForFile)
    {
      wordCounts[wordInfo.first] += wordInfo.second;
    }
  }
  
  std::cout << wordCounts.size() << " words found.  Most common:\n";
  const std::size_t maxWordsToShow = 20;
  showCommonWords(wordCounts.begin(), wordCounts.end(), std::min(wordCounts.size(), maxWordsToShow));
}
