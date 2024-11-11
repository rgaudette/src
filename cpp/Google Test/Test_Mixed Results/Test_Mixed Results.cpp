#include "gtest/gtest.h"


TEST(Test_MixedResults, mixed_fail)
{
  EXPECT_TRUE(false);
}


TEST(Test_MixedResults, mixed_pass)
{
  EXPECT_TRUE(true);
}


int main(int argc, char * argv[])
{
  ::testing::InitGoogleTest(&argc, argv);
  int status = RUN_ALL_TESTS();
  return status;
}
