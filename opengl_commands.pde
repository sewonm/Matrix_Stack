ArrayList<float[][]> stack = new ArrayList<float[][]>();

boolean orthoState = true;   

float newL;
float newR; 
float newB; 
float newT;

float perspFovDeg;
float fovTan;   


boolean shape = false;
boolean firstP = false;
float firsX;
float firsY;


void Init_Matrix()
{
  stack.clear();
  float[][] id = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
  
  stack.add(id);
  
}

void Push_Matrix()
{
  float[][] current = stack.get(stack.size()-1);
  float[][] copy = new float[4][4];
  for (int i = 0; i < 4; i++){
    for (int j = 0; j < 4; j++){
      copy[i][j] = current[i][j];
    }
  }
  stack.add(copy);
}

void Pop_Matrix()
{
  if(stack.size() <= 1) {
    println("Error: cannot pop the matrix stack");
    return;
  }
  stack.remove(stack.size()-1);
  
}

void Print_CTM()
{
  float[][] current = stack.get(stack.size()-1);
  for (int i = 0; i < current.length; i++) {
    for (int j = 0; j < current[i].length; j++) {
      print(current[i][j] + " ");
    }
    print("\n");
  }
  print("\n");
  
}

float[][] matrixMult(float[][] matrix1, float[][] matrix2) {
  float[][] result = new float[4][4];

  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      result[i][j] = 0;
      for (int k = 0; k < 4; k++) {
        result[i][j] += matrix1[i][k] * matrix2[k][j];
      }
    }
  }
  return result;
}

void Translate(float x, float y, float z)
{
    
  float[][] trans = {{1, 0, 0, x}, {0, 1, 0, y}, {0, 0, 1, z}, {0, 0, 0, 1}};
  int CTM = stack.size()-1;
  
  float[][] newMatrix = matrixMult(stack.get(CTM), trans);
  
  stack.set(CTM, newMatrix);
  
}

void Scale(float x, float y, float z)
{
  float[][] trans = {{x, 0, 0, 0}, {0, y, 0, 0}, {0, 0, z, 0}, {0, 0, 0, 1}};
  int CTM = stack.size()-1;
  
  float[][] newMatrix = matrixMult(stack.get(CTM), trans);
  
  stack.set(CTM, newMatrix);
  
}

void RotateX(float theta)
{
  theta = radians(theta);
  float[][] trans = {{1, 0, 0, 0}, 
                    {0, cos(theta), -sin(theta), 0}, 
                    {0, sin(theta), cos(theta), 0}, {0, 0, 0, 1}};
  int CTM = stack.size()-1;
  
  float[][] newMatrix = matrixMult(stack.get(CTM), trans);
  
  stack.set(CTM, newMatrix);
  
}

void RotateY(float theta)
{
  theta = radians(theta);
  float[][] trans = {{cos(theta), 0, sin(theta), 0}, 
                      {0, 1, 0, 0}, 
                      {-sin(theta), 0, cos(theta), 0}, {0, 0, 0, 1}};
  int CTM = stack.size()-1;
  
  float[][] newMatrix = matrixMult(stack.get(CTM), trans);
  
  stack.set(CTM, newMatrix);
  
}

void RotateZ(float theta)
{
  theta = radians(theta);
  float[][] trans = {{cos(theta), -sin(theta), 0, 0}, 
                      {sin(theta), cos(theta), 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
  int CTM = stack.size()-1;
  
  float[][] newMatrix = matrixMult(stack.get(CTM), trans);
  
  stack.set(CTM, newMatrix);

  
}



void Perspective(float fov, float near, float far) {
  orthoState = false;
  perspFovDeg = fov;
  fovTan = tan(radians(fov) * 0.5);
}

void Ortho(float l, float r, float b, float t, float n, float f) {
  orthoState = true;
  newL = l; 
  newR = r;
  newB = b; 
  newT = t;

}

void Begin_Shape() {
  shape = true;
  firstP = false;
}

void Vertex(float x, float y, float z) {
  float[][] M = stack.get(stack.size()-1);

  float xT = M[0][0]*x + M[0][1]*y + M[0][2]*z + M[0][3];
  float yT = M[1][0]*x + M[1][1]*y + M[1][2]*z + M[1][3];
  float zT = M[2][0]*x + M[2][1]*y + M[2][2]*z + M[2][3];
  
  float sx, sy;

  if (orthoState) {
    float nx = (xT - newL) / (newR - newL);
    float ny = (yT - newB) / (newT - newB);

    sx = nx * (width - 1);
    sy = (1 - ny) * (height - 1);
  } else {
    float xN = (xT / -zT) / fovTan; 
    float yN = (yT / -zT) / fovTan;
    sx = (xN + 1) * 0.5 * (width - 1);
    sy = (1 - (yN + 1) * 0.5) * (height - 1);
  }
  if (!firstP) {
    firsX = sx;
    firsY = sy;
    firstP = true;
  } else {
    line(firsX, firsY, sx, sy);
    firstP = false;
  }
}


void End_Shape() {
  shape = false;
  firstP = false;
}
