#include "gtest/gtest.h"


TEST(Test_SimpleFail, simple_fail)
{
  EXPECT_TRUE(false);
}


TEST(Test_SimpleFail, simple_greater_than_fail)
{
  EXPECT_GT(-1.0, 0.0);
}


int main(int argc, char * argv[])
{
  ::testing::InitGoogleTest(&argc, argv);
  int status = RUN_ALL_TESTS();
  return status;
}