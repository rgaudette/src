// Counting Words Across Files 98.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

// RJG: A map containing words with the associated counts of that
typedef std::map<std::string, std::size_t> WordCountMapType;

// RJG: Given a filename, read the file counting the number of occurrences of each word in the file
WordCountMapType wordsInFile(const char * const fileName)    // for each word
{
  // in file, return
  std::ifstream file(fileName); // # of
  WordCountMapType wordCounts; // occurrences
  // RJG: interesting, the insert operator on a ifstream just reads in a single word, what about punctuation
  for (std::string word; file >> word;)
  {
    ++wordCounts[word];
  }
  return wordCounts;
}


// QUESTION: why create a whole class and use the function operator as a simple comparison functions, seems way to 
// complicated
struct Ptr2Pair2ndGT   // compare 2nd
{
  template<typename It> // components of
  bool operator()(It it1, It it2) const
  {
    return it1->second > it2->second;  // pointed-to pairs
  }
};

// RJG: He is being really generic here, for this program we will always use the WordCountMapType iterators as calls 
// into this function.  Currently, for me it would be easier to read without the template
template<typename MapIt> // print n most
void showCommonWords(MapIt begin, MapIt end, const std::size_t n)     // common words
{
  // RJG:Define a pair of types
	//  a container of iterators into the map type
	//  an iterator for the above container
  typedef std::vector<MapIt> TempContainerType;
  typedef typename TempContainerType::iterator IterType;
  
  // RJG: we are going to use iterators into the WordCountTypeMap
  TempContainerType wordIters;
  wordIters.reserve(std::distance(begin, end));
  
  // RJG: Populate the local temp iterator container
  for (MapIt i = begin; i != end; ++i) 
    wordIters.push_back(i);
  
  // RJG: Define an iterator that specifies the end of the partial sort
  IterType sortedRangeEnd = wordIters.begin() + n;

  // RJG: partially sort the temp iterators
  std::partial_sort(wordIters.begin(), sortedRangeEnd, wordIters.end(), Ptr2Pair2ndGT());
  
  for (IterType it = wordIters.begin(); it != sortedRangeEnd; ++it)
  {
    std::printf("  %-10s%10u\n", (*it)->first.c_str(), (*it)->second);
  }
}


int main(int argc, const char ** argv)      // take list of file names on command line,
{

  WordCountMapType wordCounts;
  for (int argNum = 1; argNum < argc; ++argNum)
  {
    // RJG: compute the word occurrence count for the current file
    const WordCountMapType wordCountInfoForFile = wordsInFile(argv[argNum]);
    
    // RJG: accumulate the total word occurrence
    for (WordCountMapType::const_iterator i = wordCountInfoForFile.begin(); i != wordCountInfoForFile.end(); ++i)
    {
      wordCounts[i->first] += i->second;
    }
  }
  
  std::cout << wordCounts.size() << " words found.  Most common:\n";
  
  // print 20 most common words within
  const std::size_t maxWordsToShow = 20;
  showCommonWords(wordCounts.begin(), wordCounts.end(), std::min(wordCounts.size(), maxWordsToShow));
}