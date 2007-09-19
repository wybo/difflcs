#include <stdio.h>
#include <string.h>
#include <time.h> // for benchmarking

void find_common_substrings(char *str, char *str2, int minlen)
{
  int i, j;
  int lcs_end_pos = -1;
  int lcs_length = -1;
  int matrix_curr_row;

  int strlen1 = strlen(str);
  if (strlen1 == 0) return ;

  int strlen2 = strlen(str2);
  if (strlen2 == 0) return ;

  int matrix[strlen1][2];
  int len = 0;

  // initialize matrix
  for (i = 0; i < strlen1; ++i)
  {
    matrix[i][0] = 0;
    matrix[i][1] = 0;
  }
  matrix_curr_row = 0;

  // do the actual matching
  for (j = 0; j < strlen2; ++j)
  {
    for (i = 0; i < strlen1; ++i)
    {
      if (str[i] != str2[j])
        matrix[i][matrix_curr_row] = matrix[i][1-matrix_curr_row];
      else
      {
        if (i == 0 || j == 0)
          matrix[i][matrix_curr_row] = 1;
        else
          matrix[i][matrix_curr_row] = 1 + matrix[i-1][1-matrix_curr_row];
      }
    }
    matrix_curr_row = 1 - matrix_curr_row;
  }

  // now that matching has finished, extract position ranges from the matrix
  for (i=strlen1 - 1; i >= 0; --i)
    if (matrix[i][1-matrix_curr_row] > minlen)
    {
      printf("Found common substring starting at %d, ending at %d\n", 
               (i - matrix[i][1-matrix_curr_row]), // startpos
               i); // endpos
      i -= matrix[i][1-matrix_curr_row];
    }
}

int main(int argc, char **argv)
{
  char str[] = "let's go shopping in the mall! Far out in the uncharted backwaters of the unfashionable end of the western spiral arm of the Galaxy lies";
  char str2[] = "uncharteaaamall";
  int minlen = 3;

  find_common_substrings(str, str2, minlen);

  printf("TOTAL RUNNING TIME: %f\n", clock()/(float)CLOCKS_PER_SEC);

  return 0;
}
