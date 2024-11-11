#define TWT_RANK 0
#define HZWT_RANK 1
#define VTWT_RANK 2

int DoTemporalWT(int argc, char *argv[]);
int DoHorizontalWT();
int DoVerticalWT();
int mpiSendMatrix(Matrix Data, int rank);
int mpiRecvMatrix(Matrix *Data, int rank);
