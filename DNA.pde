import java.util.EnumSet;  //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//

enum _type { 
  // arity 1
  SIN, COS, ASIN, ACOS, TAN, ATAN, EXP, SQRT, LOG, ABS, 
    // arity 2
    ADD, SUB, MULT, DIV, MOD, POW, bAND, bOR, XOR, 
    // arity 3
    IFTHEN, 
    // terminals
    VAR, CONST, 
    // Exclude for now
    EQUALS, LT, GT, NOISE, RANDOMGAUSS, NONE
};

EnumSet<_type> bools = EnumSet.of(_type.EQUALS, _type.LT, _type.GT, _type.NONE, _type.NOISE, _type.RANDOMGAUSS); // TODO: IMPLEMENT NOISE, RANDOMGAUSS
EnumSet<_type> nonbools = EnumSet.complementOf(bools);


class DNA {
  Node root;

  DNA() {
    root = randTree(MAX_DEPTH);
  }

  Node randTree(int depth) {
    float probVar = map(abs(depth - 0), MAX_DEPTH, 0, 0, 1);
    if (random(1) < probVar) {
      return randVar();
    }
    Node root = randNode();
    if (root.n_args > 0) {
      print("C");
      if (root.type == _type.IFTHEN) {
        Node bool = randBool();
        for (int i = 0; i < bool.n_args; i++) {
          bool.args.add(randTree(depth-1));
        }
        root.args.add(bool);
        root.args.add(randTree(depth-1));
        root.args.add(randTree(depth-1));
        return root;
      }
      for (int i = 0; i < root.n_args; i++) {
        root.args.add(randTree(depth-1));
      }
    }
    return root;
  }

  Node randNode() {
    Node rand = new Node();
    rand.type = _type.values()[int(random(_type.values().length - 7))];
    rand.n_args = getNumInputs(rand);
    return rand;
  }

  Node randVar() {
    switch (int(random(2))) {
    case 0:
      return new X();
    default:
      return new Y();
    }
  }

  Node randBool() {
    //EQUALS, LT, GT
    Node rand = new Node();
    switch((int)random(3)) {
    case 0:
      rand.type = _type.EQUALS;
      break;
    case 1:
      rand.type = _type.LT;
      break;
    case 2:
      rand.type = _type.GT;
      break;
    }
    rand.n_args = 2;
    return rand;
  }

  int getNumInputs(Node node) {
    switch(node.type) {
    case VAR:
    case CONST:
      return 0;
    case SIN:
    case COS:
    case ASIN:
    case ACOS:
    case TAN:
    case ATAN:
    case EXP:
    case SQRT:
    case LOG:
    case ABS:
      return 1;
    case ADD:
    case SUB:
    case MULT:
    case DIV:
    case MOD:
    case EQUALS:
    case LT:
    case GT:
    case NOISE:
    case RANDOMGAUSS:
    case POW:
    case bAND:
    case bOR:
    case XOR:
      return 2;
    case IFTHEN:
      return 3;
    default:
      print("WTF");
      return 0;
    }
  }
  float getColorVal(int x, int y, int w) {
    float norm_x = 2*((float)x) / ((float)w) - 1.0;  
    float norm_y = 2*((float)y) / ((float)w) - 1.0;
    float col = this.getRootVal(norm_x, norm_y);
    print("\n");
    col = col/(1+col);
    
    if (col == Float.NaN) print("Error NaNNNNNNNNNNNNNNNNNNNNNNNNNN"); 
    //print("col: " + col + "\n");
    //col *= 255;
    return col;
    //return min(255, max(0, (int)col));
  }

  float getRootVal(float x, float y) {
    if (root != null) return root.getVal(x, y);
    print("wtf"); 
    return -1;
  }

  class Node {
    ArrayList<Node> args;
    _type type;
    int n_args;

    Node() {
      args = new ArrayList<Node>();
      type = _type.NONE;
    }

    float getVal(float x, float y) {
      print(this.type + " ");
      switch(this.type) {
      case VAR:
      case CONST:
        return this.getVal(x, y);

      case SIN:
        return sin(args.get(0).getVal(x, y));
      case COS:
        return cos(args.get(0).getVal(x, y));
      case ASIN:
        //input range [-1,1] output [-PI/2, PI/2]
        return asin(args.get(0).getVal(x, y));
      case ACOS:
        return acos(args.get(0).getVal(x, y));
      case TAN:
        return tan(args.get(0).getVal(x, y));
      case ATAN:
        return atan(args.get(0).getVal(x, y));
      case EXP:
        return exp(args.get(0).getVal(x, y));
      case SQRT:
        return sqrt(abs(args.get(0).getVal(x, y)));
      case LOG:
        return log(abs(args.get(0).getVal(x, y)));
      case ABS:
        return abs(args.get(0).getVal(x, y));
        //          ADD, SUB, MULT, DIV, MOD, EQUALS, LT, GT, NOISE, RANDOMGAUSS, POW, 

      case ADD:
        return args.get(0).getVal(x, y) + args.get(1).getVal(x, y);
      case SUB:
        return args.get(0).getVal(x, y) - args.get(1).getVal(x, y);
      case MULT:
        return args.get(0).getVal(x, y) * args.get(1).getVal(x, y);
      case DIV:
        if (args.get(1).getVal(x,y) == 0) {
          return args.get(0).getVal(x, y) / (args.get(1).getVal(x, y) + 0.1);  // never divide by 0
        }
        return args.get(0).getVal(x, y) / args.get(1).getVal(x, y);
      case MOD:
        return args.get(0).getVal(x, y) % args.get(1).getVal(x, y);
      case POW:
        return pow(args.get(0).getVal(x, y), args.get(1).getVal(x, y));
      case bAND:
        return int(args.get(0).getVal(x, y)) & int(args.get(1).getVal(x, y)); //int casting???
      case bOR:
        return int(args.get(0).getVal(x, y)) | int(args.get(1).getVal(x, y));
      case XOR:
        return int(args.get(0).getVal(x, y)) ^ int(args.get(1).getVal(x, y));

      case IFTHEN:
        return args.get(0).getBoolVal(x, y) ? args.get(1).getVal(x, y) : args.get(2).getVal(x, y);
      default:
        print("Error: " + this.type + "\n");
        return 1;
      }
    }

    boolean getBoolVal(float x, float y) {
      switch(type) {
      case EQUALS:
        return args.get(0).getVal(x, y) == args.get(1).getVal(x, y);
      case LT:
        return args.get(0).getVal(x, y) < args.get(1).getVal(x, y);
      case GT:
        return args.get(0).getVal(x, y) > args.get(1).getVal(x, y);
      default:
        print("Error: trying to get boolean value from non-boolean function\n");
        return false;
      }
    }
  }
  class X extends Node {
    X() {
      type = _type.VAR;
    }
    float getVal(float x, float y) { 
      print("X");
      return x;
    }
  }

  class Y extends Node {
    Y() {
      type = _type.VAR;
    }
    float getVal(float x, float y) { 
      print("Y");
      return y;
    }
  }

  class Const extends Node {
    Const() {
      type = _type.CONST;
    }
    float getVal(float x, float y) { 
      return 1;    //TODO!
    }
  }
}
