#include "gtest/gtest.h"


TEST(Test_SimplePass, simple_pass)
{
  EXPECT_TRUE(true);
}


TEST(Test_SimplePass, simple_greater_than_pass)
{
  EXPECT_GT(1.0, 0.0);
}


int main(int argc, char * argv[])
{
  ::testing::InitGoogleTest(&argc, argv);
  int status = RUN_ALL_TESTS();
  return status;
}