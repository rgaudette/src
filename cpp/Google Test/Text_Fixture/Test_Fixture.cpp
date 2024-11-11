#include <gtest/gtest.h>


class Test_Fixture_Name : public ::testing::Test
{
public:
  int value = 0;

protected:
  virtual void SetUp() override
  {
    value = 1;
  }

  virtual void TearDown() override
  {
    value = 2;
  }
};


TEST_F(Test_Fixture_Name, test_fixture_pass)
{
  EXPECT_EQ(value, 1);
}


TEST_F(Test_Fixture_Name, test_fixture_fail)
{
  EXPECT_EQ(value, 2);
}


int main(int argc, char ** argv)
{

  ::testing::InitGoogleTest(&argc, argv);
  int status = RUN_ALL_TESTS();
  return status;
}

