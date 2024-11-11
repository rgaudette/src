/***********************************************************/
/*                                                         */
/* Function: randnum()                                     */
/*           This function generates a random number based */
/*           upon a uniformly distributed random variable. */
/*                                                         */
/***********************************************************/

float randnum (long int *seed_adr)
{
      long int zi, lowprd, hi31;

      zi          = *seed_adr;
      lowprd      = (zi &  65535) * 24112;
      hi31        = (zi >>    16) * 24112 + (lowprd >> 16);
      zi          = ((lowprd & 65535) - 2147483647) +
		    ((hi31 & 32767) << 16) + (hi31 >> 15);
      if (zi < 0)   { zi += 2147483647; }
      lowprd      = (zi & 65535) * 26143;
      hi31        = (zi >> 16) * 26143 + (lowprd >> 16);
      zi          = ((lowprd & 65535) - 2147483647) +
		    ((hi31 & 32767) << 16) + (hi31 >> 15);
      if (zi < 0)   { zi += 2147483647; }
      *seed_adr   = zi;
      return        (((zi >> 7 | 1 ) + 1) / 16777216.0);
}
