#include <stdio.h>

int main(int argc, char *argv[]) {
    int i, count, type, rows, cols, imag, len, flag;
    FILE *fp;

    for(i = 1; i < argc; i++) {
        fp = fopen(argv[i], "r+");
        if(fp == NULL) {
            fprintf(stderr, "Unable to open %s\n", argv[i]);
        }
        else {

            flag = 1;

            while(flag) {
                count = fread(&type, sizeof(int), 1, fp);
                if(count != 1)
                  break;

                if(type != 1000) {
                    fprintf(stderr, "Type %d\n", type);
                    fprintf(stderr, "Found a type not equal to 1000 in %s\n",
                            argv[i]);
                    exit(-1);
                }
                else {
                    fseek(fp, -4, SEEK_CUR); 
                    type = 0;
                    count = fwrite(&type, sizeof(int), 1, fp);
                    fprintf(stderr, "Count %d\n", count);
                    if(count == 0) {
                        fprintf(stderr, "%d\n", ferror(fp));
                    }
                }

                count = fread(&rows, sizeof(int), 1, fp);
                fprintf(stderr, "count %d\t rows %d\n", count, rows);
                if(count != 1) {
                    fprintf(stderr, "Error reading rows in %s\n", argv[i]);
                    exit(-1);
                }
                count = fread(&cols, sizeof(int), 1, fp);
                fprintf(stderr, "count %d\t cols %d\n", count, cols);
                if(count != 1) {
                    fprintf(stderr, "Error reading cols in %s\n", argv[i]);
                    exit(-1);
                }
                count = fread(&imag, sizeof(int), 1, fp);
                fprintf(stderr, "count %d\t imag %d\n", count, imag);
                if(count != 1) {
                    fprintf(stderr, "Error reading imag in %s\n", argv[i]);
                    exit(-1);
                }
                count = fread(&len, sizeof(int), 1, fp);
                fprintf(stderr, "count %d\t len %d\n", count, len);
                if(count != 1) {
                    fprintf(stderr, "Error reading len in %s\n", argv[i]);
                    exit(-1);
                }
                fseek(fp, len, SEEK_CUR);
                fseek(fp, rows*cols*sizeof(double), SEEK_CUR);
            }
        }

        fclose(fp);

    }
    return(0);
}           
                  
