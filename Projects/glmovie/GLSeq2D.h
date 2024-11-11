//
//  GLSeq2D class.  Implements an OpenGL 2D spatial sequence
//
#define VIEWPORT_XMIN       0.05f
#define VIEWPORT_YMIN       0.05f
#define VIEWPORT_XWDTH      0.8f
#define VIEWPORT_YWDTH      0.9f
#define VIEWPORT_CBWIDTH    0.05f
#define VIEWPORT_XSPC       0.05f

enum DTYPE {DT_COLORMAP=0, DT_MESH = 1, DT_SURFACE = 2, DT_TRIFIELD = 3};

class GLSeq2D {
private:
	int flgOrtho;

    float       Cmin, Cmax;
    float       minData, maxData;
    int         idxFrame, nFrames, nRows, nCols, nElements;
    int         flgShowGrid, flgShowColorBar;
    const float *real, *imag;
    GLsizei     WndWidth, WndHeight;
    GLfloat     *xVertices, *yVertices;
    DTYPE DisplayType;
    
    //
    //  Colormap variables
    //
    int     CmapType;
    GLfloat *rCMap;
    GLfloat *gCMap;
    GLfloat *bCMap;
    int     nColors;
    int	    *idxColor;
    BOOL    flgDataSet;

    //
    //  Internal calculation functions
    //
    void CalcTriangleVertices(void);
    void CalcCMapVertices(void);
    void CalcRange();
    void SetView(void);
    void RenderTriangles(void);
    void RenderColorMap();
    void RenderColorBar(void);
    void RenderGrid(void);
    void CMap_bgyor(void);

public:
	void SetViewFill();
	void SetViewOrtho();
    //
    //  Class interface functions
    //
    GLSeq2D();
    ~GLSeq2D();
    void SetDisplayType(int dt);
	void SetColorBarFlag(int cbf);
	void SetGridFlag(int fsg);
	int GetFrameIdx();
    void SetFieldSize(int nr, int nc, int nf);
    void ReallocVertices();
    void UpdateData(const float *reVector, const float *imVector);
    void RenderWindow(void);
    float GetDataMax(void);
    float GetDataMin(void);
    void SetCRange(float ColorMin, float ColorMax);
    void SetCMapType(int cmt);
    void SetWindowSize(int cx, int cy);
    void ResetFrame(void);
    void IncrementFrame(int StepSize);
    void DecrementFrame(int StepSize);
};
