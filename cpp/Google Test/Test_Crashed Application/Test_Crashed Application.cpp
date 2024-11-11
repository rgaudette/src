#include "gtest/gtest.h"


TEST(Test_CrashedApp, mixed_fail)
{
  int * bad_memory_location = nullptr;
  bad_memory_location[0] = 1;
  EXPECT_TRUE(true);
}


int main(int argc, char * argv[])
{
  ::testing::InitGoogleTest(&argc, argv);
  int status = RUN_ALL_TESTS();
  return status;
}

