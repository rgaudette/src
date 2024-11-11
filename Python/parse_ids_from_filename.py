from re import split

def parse_ids_from_filename(filename):
    """
    Extract the reconstruction region ID, focus group ID and wavelet level from a sharpness profile, model or
    reconstruction image filename
    """

    # Remove the file extension if any
    extension_split = split('\.', filename)

    # split the basename by underscores
    field_split = split('_', extension_split[0])
    
    n_tokens = len(field_split)
    if n_tokens < 4:
        raise ValueError("Unable to find enough tokens in the filename: %s" % filename)
    
    # Remove the prefixes and convert the IDs to integers
    rrid_str = field_split[n_tokens - 3]
    rrid = int(rrid_str[1:])
    
    fgid_str = field_split[n_tokens - 2]
    fgid = int(fgid_str[1:])

    level_str = field_split[n_tokens - 1]
    level = int(level_str[1:])

    return rrid,fgid,level

# Unit test
import unittest

class TestParseIDsFromFileName(unittest.TestCase):

    def test_parse_sharpness_file_id(self):
        filename = "sharpness_R12345_F345_L2.txt"
        expected_rrid = 12345
        expected_fgid = 345
        expected_level = 2

        rrid,fgid,level = parse_ids_from_filename(filename)
        
        self.assert_all_return_values(expected_rrid, rrid, expected_fgid, fgid, expected_level, level)


    def test_parse_sharpness_pre_file_id(self):
        filename = "sharpness_pre_R02782_F12842_L4.txt"
        expected_rrid = 2782
        expected_fgid = 12842
        expected_level = 4

        rrid,fgid,level = parse_ids_from_filename(filename)

        self.assert_all_return_values(expected_rrid, rrid, expected_fgid, fgid, expected_level, level)


    def test_parse_model_file_id(self):
        filename = "gaussian_coarse_R00312_F927_L0.txt"
        expected_rrid = 312
        expected_fgid = 927
        expected_level = 0

        rrid,fgid,level = parse_ids_from_filename(filename)

        self.assert_all_return_values(expected_rrid, rrid, expected_fgid, fgid, expected_level, level)

    def test_parse_recon_image_file_id(self):
        filename = "recon_image_R00312_F927_L0.txt"
        expected_rrid = 312
        expected_fgid = 927
        expected_level = 0

        rrid,fgid,level = parse_ids_from_filename(filename)

        self.assert_all_return_values(expected_rrid, rrid, expected_fgid, fgid, expected_level, level)

    def test_parse_bad_filename(self):
        filename = "sharpness_R12345_F345.txt"
        
        self.assertRaises(ValueError, parse_ids_from_filename, filename)


    # Check that all return values match their expected values
    def assert_all_return_values(self, expected_rrid, rrid, expected_fgid, fgid, expected_level, level):
        self.assertEqual(expected_rrid, rrid,
            "reconstruction region ID parsed incorrectly, expected %d, got %d" % (expected_rrid, rrid))
        self.assertEqual(expected_fgid, fgid,
            "focus group ID parsed incorrectly, expected %d, got %d" % (expected_fgid, fgid))
        self.assertEqual(expected_level, level,
            "wavelet level parsed incorrectly, expected %d, got %d" % (expected_level, level))


if __name__ == '__main__':
    unittest.main()
