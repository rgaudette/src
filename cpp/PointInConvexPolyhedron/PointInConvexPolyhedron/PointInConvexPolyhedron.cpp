#include <vector>
#include <cassert>
#include <iostream>
#include <cmath>

#include "gtest/gtest.h"


// TODO: templatize this
// TODO: make this compatible with any Vector in the v810 code
struct Vector
{
  double x, y, z;

  Vector operator-(Vector vector) const
  {
    return Vector{ x - vector.x, y - vector.y, z - vector.z};
  }

  Vector cross(Vector vector) const
  {
    return Vector
    {
      y * vector.z - vector.y * z,
      z * vector.x - vector.z * x,
      x * vector.y - vector.x * y
    };
  }


  double dot(Vector vector) const
  {
    return x * vector.x + y * vector.y + z * vector.z;
  }

  double norm() const
  {
    return std::sqrt(x * x + y * y + z * z);
  }
};

using Point = Vector;

// A Face structure, consists of 3 points ordered such that the cross product between the vector formed by
// the 0th and 1st point and the vector 0th and 2nd point defines the "outside" of the surface.  This is the normal
// vector returned by normal().
struct Face
{
  std::vector<Point> vertex;

  Vector normal() const
  {
    assert(vertex.size() > 2);
    Vector dir1 = vertex[1] - vertex[0];
    Vector dir2 = vertex[2] - vertex[0];
    Vector normal_vec = dir1.cross(dir2);
    auto normal_mag = normal_vec.norm();
    return Vector{normal_vec.x / normal_mag, normal_vec.y / normal_mag, normal_vec.z / normal_mag};
  }
};


// Check to see if the point is on the "inside" or "outside" of the face, this function returns a positive value if the
// point is on the inside of the face, a negative value if it is on the outside, and 0.0 if the point is on the face
double is_inside_face(Face const & face, Point const & point)
{
  Vector point_to_face = face.vertex[0] - point;
  Vector face_normal = face.normal();
  auto d = point_to_face.dot(face_normal);
  // for numeric stability
  d /= point_to_face.norm();
  return d;
}


bool isInConvexPoly(Point const & point, std::vector<Face> const & faces)
{
  for (Face const & face : faces)
  {
    auto d = is_inside_face(face, point);
    // TODO: change this to be typename dependent
    // slighly below zero to allow for points near the face boundaries
    constexpr auto bound = -5.0 * std::numeric_limits<double>::epsilon();
    if (d < bound)
      return false;
  }

  return true;
}

//
// Unit tests
//

// A simple test fixture with two Faces, one whos outside is the -z half space and one whos outside is the
// +z half space
class TestIsOutsideFace : public ::testing::Test
{
  protected:
    Face z_plane_negative_inside{{Point{0, 0, 0}, Point{1, 0, 0}, Point{0, 1, 0}}};
    Face z_plane_positive_inside{{Point{0, 0, 0}, Point{0, 1, 0}, Point{1, 0, 0}}};
};


TEST_F(TestIsOutsideFace, negative_inside_point_below_z_plane)
{
  auto result = is_inside_face(z_plane_negative_inside, Point { 0.0, 0.0 , -1.0 });
  EXPECT_GT(result, 0.0);
}


TEST_F(TestIsOutsideFace, negative_inside_point_above_z_plane)
{
  auto result = is_inside_face(z_plane_negative_inside, Point{0.0, 0.0 , 1.0 });
  EXPECT_LT(result, 0.0);
}


TEST_F(TestIsOutsideFace, positive_inside_point_below_z_plane)
{
  auto result = is_inside_face(z_plane_positive_inside, Point{0.0, 0.0 , -1.0 });
  EXPECT_LT(result, 0.0);
}


TEST_F(TestIsOutsideFace, positive_inside_point_above_z_plane)
{
  auto result = is_inside_face(z_plane_positive_inside, Point{0.0, 0.0 , 1.0 });
  EXPECT_GT(result, 0.0);
}

//  A unit cube test fixture
class TestUnitCube : public ::testing::Test
{
  protected:
    std::vector<Face> cube
    {
      Face{ { Point{0, 0, 0}, Point{1, 0, 0}, Point{1, 0, 1}, Point{0, 0, 1 } }}, // front
      Face{ { Point{0, 1, 0}, Point{0, 1, 1}, Point{1, 1, 1}, Point{1, 1, 0 } }}, // back
      Face{ { Point{0, 0, 0}, Point{0, 0, 1}, Point{0, 1, 1}, Point{0, 1, 0 } }}, // left
      Face{ { Point{1, 0, 0}, Point{1, 1, 0}, Point{1, 1, 1}, Point{1, 0, 1 } }}, // right
      Face{ { Point{0, 0, 1}, Point{1, 0, 1}, Point{1, 1, 1}, Point{0, 1, 1 } }}, // top
      Face{ { Point{0, 0, 0}, Point{0, 1, 0}, Point{1, 1, 0}, Point{1, 0, 0 } }}, // bottom
    };
};


TEST_F(TestUnitCube, point_in_unit_cube)
{
  Point p {0.5, 0.5, 0.5};
  EXPECT_TRUE(isInConvexPoly(p, cube));
}


TEST_F(TestUnitCube, x_out_of_unit_cube)
{
  Point p {1.5, 0.5, 0.5};
  EXPECT_FALSE(isInConvexPoly(p, cube));
}


TEST_F(TestUnitCube, y_out_of_unit_cube)
{
  Point p {0.5, 1.2, 0.5};
  EXPECT_FALSE(isInConvexPoly(p, cube));
}


TEST_F(TestUnitCube, z_out_of_unit_cube)
{
  Point p {0.5, 0.5, -0.5};
  EXPECT_FALSE(isInConvexPoly(p, cube));
}


// A test fixture defining a tetrahedron with the top chopped off
class TestTetrahedron : public ::testing::Test
{
  protected:
    double x_value = 3.0;
    double y_value = 3.0;
    double z_value = 4.0;

    std::vector<Face> chopped_tetrahedron  // Unit cube
    {
      // Front faces, two triangular faces form a quadrilateral surface
      Face{{
          Point{ -2.0 * x_value, -2.0 * y_value, -2.0 * z_value},
          Point{2.0 * x_value, -2.0 * y_value, -2.0 * z_value},
          Point{x_value, -y_value, -z_value},
        }},
      Face{{
          Point{ -2.0 * x_value, -2.0 * y_value, -2.0 * z_value},
          Point{x_value, -y_value, -z_value},
          Point{ -x_value, -y_value, -z_value}
        }},

      // Back faces
      Face{{
          Point{2.0 * x_value, 2.0 * y_value, -2.0 * z_value},
          Point{ -2.0 * x_value, 2.0 * y_value, -2.0 * z_value},
          Point{ -x_value, y_value, -z_value}
        }},
      Face{{
          Point{2.0 * x_value, 2.0 * y_value, -2.0 * z_value},
          Point{ -x_value, y_value, -z_value},
          Point{x_value, y_value, -z_value}
        }},

      // Side (+x)
      Face{{
          Point{2.0 * x_value, -2.0 * y_value, -2.0 * z_value},
          Point{2.0 * x_value, 2.0 * y_value, -2.0 * z_value},
          Point{x_value, y_value, -z_value}
        }},
      Face{{
          Point{2.0 * x_value, -2.0 * y_value, -2.0 * z_value},
          Point{x_value, y_value, -z_value},
          Point{x_value, -y_value, -z_value}
        }},

      // Side (-x)
      Face{{
          Point{ -2.0 * x_value, -2.0 * y_value, -2.0 * z_value},
          Point{ -x_value, y_value, -z_value},
          Point{ -2.0 * x_value, 2.0 * y_value, -2.0 * z_value}
        }},
      Face{{
          Point{ -2.0 * x_value, -2.0 * y_value, -2.0 * z_value},
          Point{ -x_value, -y_value, -z_value},
          Point{ -x_value, y_value, -z_value}
        }},

      // Top
      Face{{
          Point{x_value, -y_value, -z_value},
          Point{x_value, y_value, -z_value},
          Point{ -x_value, y_value, -z_value}
        }},
      Face{{
          Point{x_value, -y_value, -z_value},
          Point{ -x_value, y_value, -z_value},
          Point{ -x_value, -y_value, -z_value}
        }},

      // Bottom
      Face{{
          Point{2.0 * x_value, -2.0 * y_value, -2.0 * z_value},
          Point{ -2.0 * x_value, 2.0 * y_value, -2.0 * z_value},
          Point{2.0 * x_value, 2.0 * y_value, -2.0 * z_value}
        }},
      Face{{
          Point{2.0 * x_value, -2.0 * y_value, -2.0 * z_value},
          Point{ -2.0 * x_value, -2.0 * y_value, -2.0 * z_value},
          Point{ -2.0 * x_value, 2.0 * y_value, -2.0 * z_value}
        }}
    };
};


TEST_F(TestTetrahedron, center_of_tetrahedron)
{
  Point p{ 0.0, 0.0, -1.5 * z_value};
  EXPECT_TRUE(isInConvexPoly(p, chopped_tetrahedron));
}


TEST_F(TestTetrahedron, in_front_of_tetrahedron)
{
  Point p{ 0.0, -1.6 * y_value, -1.5 * z_value};
  auto in_convex_polyhedron = isInConvexPoly(p, chopped_tetrahedron);
  EXPECT_FALSE(in_convex_polyhedron);
}


TEST_F(TestTetrahedron, in_back_of_tetrahedron)
{
  Point p{ 0.0, 1.6 * y_value, -1.5 * z_value};
  auto in_convex_polyhedron = isInConvexPoly(p, chopped_tetrahedron);
  EXPECT_FALSE(in_convex_polyhedron);
}


TEST_F(TestTetrahedron, beside_plus_x_tetrahedron)
{
  Point p{ 1.6 * x_value, y_value, -1.5 * z_value};
  auto in_convex_polyhedron = isInConvexPoly(p, chopped_tetrahedron);
  EXPECT_FALSE(in_convex_polyhedron);
}


TEST_F(TestTetrahedron, beside_negative_x_tetrahedron)
{
  Point p{ -1.6 * x_value, y_value, -1.5 * z_value};
  auto in_convex_polyhedron = isInConvexPoly(p, chopped_tetrahedron);
  EXPECT_FALSE(in_convex_polyhedron);
}


TEST_F(TestTetrahedron, above_tetrahedron)
{
  Point p{ 0.0, 0.0, -0.99999 * z_value};
  auto in_convex_polyhedron = isInConvexPoly(p, chopped_tetrahedron);
  EXPECT_FALSE(in_convex_polyhedron);
}


TEST_F(TestTetrahedron, below_tetrahedron)
{
  Point p{ 0.0, 0.0, -2.00001 * z_value};
  auto in_convex_polyhedron = isInConvexPoly(p, chopped_tetrahedron);
  EXPECT_FALSE(in_convex_polyhedron);
}


int main(int argc, char * argv[])
{
  ::testing::InitGoogleTest(&argc, argv);
  RUN_ALL_TESTS();
  return 0;
}
