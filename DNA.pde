enum _type { //<>// //<>// //<>// //<>//
  // arity 1
  SIN, COS, ASIN, ACOS, TAN, ATAN, EXP, SQRT, ABS, SQ, 
    // arity 2
    ADD, SUB, MULT, DIV, MOD, POW, LOG, MAG, PERLIN, 
    // arity 3
    LERP, IFGTELSE, 
    // Exclude for now
    VAR, CONST, EQUALS, LT, GT, NOISE, RANDOMGAUSS, IFTHEN
    //TODO: bAND, bOR, XOR
};


class DNA {
  Node root;
  color warm;
  color cool;

  DNA() {
    root = randTree(MAX_DEPTH);
    warm = color(random(0, 80), 100, 100);
    cool = color(random(150, 250), 100, 100);
  }

  DNA(Node r) {
    root = r;
    warm = color(random(0, 80), 100, 100);
    cool = color(random(150, 250), 100, 100);
  }

  DNA getNthNode(int current, int n) {
    return root.getNthNode(current, n);
  }

  void replace(DNA transplant) {
    if (this.root.n_args > 0) {
      int randomArgIndex = (int)random(this.root.n_args);
      this.root.args.set(randomArgIndex, transplant.root);
    } else {
       print("this shouldn't print\n");
    }
  }

  DNA copy() {
    DNA copied = new DNA();
    copied.root = root.copy();
    copied.warm = this.warm;
    copied.cool = this.cool;
    return copied;
  }

  String toStr() {
    return root.toStr();
  }

  int getHeight() {
    return root.getHeight();
  }

  int getSize() {
    return root.getSize();
  }

  Node randTree(int depth) {
    float probVar = map(depth, MAX_DEPTH, 0, 0, 1);
    if (random(1) < probVar || MAX_DEPTH == 0) {
      Node randVar = randVar();
      return randVar;
    }
    Node root = randNode();
    if (root.type == _type.IFTHEN) {
      Node bool = randBool();
      for (int i = 0; i < bool.n_args; i++) {
        bool.args.add(randNode()); //TODO; hoort randTree te zijn
      }
      root.args.add(bool);
      root.args.add(randTree(depth-1));
      root.args.add(randTree(depth-1));
      return root;
    }
    if (root.n_args > 0) {
      for (int i = 0; i < root.n_args; i++) {
        root.args.add(randTree(depth-1));
      }
    }
    return root;
  }

  Node randNode() {
    //if (random(1) < 0.2) return randVar(); //DIT KAN NIET MET TREEHEIGHT
    Node rand = new Node();
    rand.type = _type.values()[int(random((_type.values().length) - 9))];
    rand.n_args = getNumInputs(rand);
    return rand;
  }

  Node randVar() {
    switch (int(random(5))) {
    case 0:
      return new X();
    case 1:
      return new Y();
    case 2:    
      return new Ang();
    case 3:
      return new Const();
    default:
      return new Rad();
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
    case ABS:
    case SQ:
      return 1;
    case LOG:
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
    case MAG:
    case PERLIN:
      return 2;
    case LERP:
      return 3;
    case IFGTELSE:
      return 4;
    default:
      print("WTF");
      return 0;
    }
  }
  float getColorVal(int x, int y) {
    float norm_x = 2*((float)x) / ((float)w) - 1.0;  
    float norm_y = 2*((float)y) / ((float)h) - 1.0;
    float col = this.getRootVal(norm_x, norm_y);
    return col;//max(min(col, 10000000), -10000000);
    //return min(255, max(0, (int)col));
  }

  float getRootVal(float x, float y) {
    if (root != null) return root.getVal(x, y);
    print("wtf");
    return -1;
  }

  class Node {
    ArrayList<Node> args = new ArrayList<Node>();
    _type type;
    int n_args;

    Node() {
      type = _type.ADD;
    }

    DNA getNthNode(int current, int n) {
      current++;
      print(current);
      DNA nth = new DNA();
      if (current == n && this.n_args > 0) {
        nth.root = this;
        return nth;
      } else {
        if (this.n_args > 0) {
          for (int i = 0; i < this.n_args; i++) {
            nth = this.args.get(i).getNthNode(current, n);
            if (current == n) {
              print("Bgot nth node: ");
              nth.root = this;
              print(nth.toStr() + "\n");
              return nth;
            }
          }
        }
      }
      return nth;
    }

    int getSize() {
      if (this.type == _type.VAR || this.type == _type.CONST) return 0;  // does not include leaves, 1 otherwise TODO
      int m = 1;
      for (int i = 0; i < this.n_args; i++) {
        m += this.args.get(i).getSize();
      }
      return m;
    }

    int getHeight() {
      if (this.type == _type.VAR || this.type == _type.CONST) return 1;
      int m = 0;
      for (int i = 0; i < this.n_args; i++) {
        int h = args.get(i).getHeight();
        if (h > m)
          m = h;
      }
      return m + 1;
    }

    Node copy() {
      Node copied = new Node();
      copied.type = this.type;
      copied.n_args = this.n_args;
      ArrayList<Node> copiedArgs = new ArrayList<Node>();

      for (int i = 0; i < this.n_args; i++) {
        copiedArgs.add(this.args.get(i).copy());
      }
      copied.args = copiedArgs;
      return copied;
    }

    String toStr() {
      switch(this.type) {
      case VAR:
      case CONST:
        return this.toStr();
      case SIN:
        return "sin (" + this.args.get(0).toStr() + ")";
      case COS:
        return "cos (" + this.args.get(0).toStr() + ")";
      case ASIN:
        return "asin (" + this.args.get(0).toStr() + ")";
      case ACOS:
        return "acos (" + this.args.get(0).toStr() + ")";
      case TAN:
        return "tan (" + this.args.get(0).toStr() + ")";
      case ATAN:
        return "atan (" + this.args.get(0).toStr() + ")";
      case EXP:
        return "exp (" + this.args.get(0).toStr() + ")";
      case SQRT:
        return "sqrt (" + this.args.get(0).toStr() + ")";
      case ABS:
        return "abs (" + this.args.get(0).toStr() + ")";
      case SQ:
        return "(" + this.args.get(0).toStr() + ")^2";
      case LOG:
        return "log (" + this.args.get(0).toStr() + ") / log (" + this.args.get(1).toStr() + ")";
      case ADD:
        return this.args.get(0).toStr() + " + " + this.args.get(1).toStr();
      case SUB:
        return this.args.get(0).toStr() + " - " + this.args.get(1).toStr();
      case MULT:
        return this.args.get(0).toStr() + " * " + this.args.get(1).toStr();
      case DIV:
        return this.args.get(0).toStr() + " / " + this.args.get(1).toStr();
      case MOD:
        return this.args.get(0).toStr() + " % " + this.args.get(1).toStr();
      case EQUALS:
        return this.args.get(0).toStr() + " == " + this.args.get(1).toStr();
      case LT:
        return this.args.get(0).toStr() + " < " + this.args.get(1).toStr();
      case GT:
        return this.args.get(0).toStr() + " > " + this.args.get(1).toStr();
      case NOISE:
        return "noise (" + this.args.get(0).toStr() + ", " + this.args.get(1).toStr() + ")";
      case RANDOMGAUSS:
        return "nog niet geimplmemnteerd ";
      case POW:
        return "pow (" + this.args.get(0).toStr() + ", " + this.args.get(1).toStr() + ")";
      case MAG:
        return "length (" + this.args.get(0).toStr() + ", " + this.args.get(1).toStr() + ")";
      case PERLIN:
        return "perlin (" + this.args.get(0).toStr() + ", " + this.args.get(1).toStr() + ")";
      case IFTHEN:
      case IFGTELSE:
        return "if (" + this.args.get(0).toStr() + " > " + this.args.get(1).toStr() + ") {" + this.args.get(2).toStr() + "} else {" + this.args.get(3).toStr() + "}";
      case LERP:
        return "lerp (" + this.args.get(0).toStr() + ", " + this.args.get(1).toStr() + ", " + this.args.get(2).toStr() + ")";
      default:
        print("WTF");
        return "hoi";
      }
    }

    float getVal(float x, float y) {
      switch(this.type) {
      case VAR:
      case CONST:
        return this.getVal(x, y);

      case SIN:
        return sin((args.get(0).getVal(x, y)*PI)/2 + 0.5);
      case COS:
        return cos((args.get(0).getVal(x, y)*PI)/2 + 0.5);
      case ASIN:
        return asin(map4InverseTrig(args.get(0).getVal(x, y)));
      case ACOS:
        return acos(map4InverseTrig(args.get(0).getVal(x, y)));
      case TAN:
        return tan(args.get(0).getVal(x, y));
      case ATAN:
        return atan(map4InverseTrig(args.get(0).getVal(x, y)));
      case EXP:
        return exp(args.get(0).getVal(x, y));
      case SQRT:
        return sqrt(abs(args.get(0).getVal(x, y)));
      case LOG:
        return log(abs(args.get(0).getVal(x, y)))/log(abs(args.get(1).getVal(x, y)));
      case ABS:
        return abs(args.get(0).getVal(x, y));
      case SQ:
        return sq(args.get(0).getVal(x, y));
      case MAG:
        return mag(args.get(0).getVal(x, y), args.get(1).getVal(x, y));
      case ADD:
        return args.get(0).getVal(x, y) + args.get(1).getVal(x, y);
      case SUB:
        return args.get(0).getVal(x, y) - args.get(1).getVal(x, y);
      case MULT:
        return args.get(0).getVal(x, y) * args.get(1).getVal(x, y);
      case DIV:
        if (args.get(1).getVal(x, y) == 0) {
          return args.get(0).getVal(x, y) / (args.get(1).getVal(x, y) + 0.1);  // never divide by 0
        }
        return args.get(0).getVal(x, y) / args.get(1).getVal(x, y);
      case MOD:
        return args.get(0).getVal(x, y) % args.get(1).getVal(x, y);
      case POW:
        return pow(args.get(0).getVal(x, y), args.get(1).getVal(x, y));
      case PERLIN:
        return noise(args.get(0).getVal(x, y), args.get(1).getVal(x, y));
        /*case bAND:
         return int(args.get(0).getVal(x, y)) & int(args.get(1).getVal(x, y)); //int casting???
         case bOR:
         return int(args.get(0).getVal(x, y)) | int(args.get(1).getVal(x, y));
         case XOR:
         return int(args.get(0).getVal(x, y)) ^ int(args.get(1).getVal(x, y));*/
      case LERP:
        return lerp(args.get(0).getVal(x, y), args.get(1).getVal(x, y), args.get(2).getVal(x, y)/(args.get(2).getVal(x, y)+1));
      case IFTHEN:
        return args.get(0).getBoolVal(x, y) ? args.get(1).getVal(x, y) : args.get(2).getVal(x, y);
      case IFGTELSE:
        return (args.get(0).getVal(x, y) > args.get(1).getVal(x, y)) ? args.get(2).getVal(x, y) : args.get(3).getVal(x, y);
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
      n_args = 0;
    }
    float getVal(float x, float y) { 
      return x;
    }
    String toStr() {
      return "x";
    }

    Node copy() {
      return new X();
    }
  }

  class Y extends Node {
    Y() {
      type = _type.VAR;
      n_args = 0;
    }
    float getVal(float x, float y) { 
      return y;
    }
    String toStr() {
      return "y";
    }

    Node copy() {
      return new Y();
    }
  }

  class Ang extends Node {
    Ang() {
      type = _type.VAR;
      n_args = 0;
    }
    float getVal(float x, float y) { 
      return tan(y/x);
    }
    String toStr() {
      return "ang";
    }

    Node copy() {
      return new Ang();
    }
  }

  class Const extends Node {
    float val;

    Const() {
      val = random(-10, 10);
      type = _type.CONST;
      n_args = 0;
    }

    Const(float c) {
      val = c;
      type = _type.CONST;
      n_args = 0;
    }

    float getVal(float x, float y) {
      return val;
    }
    String toStr() {
      return Float.toString(val);
    }
    Node copy() {
      return new Const(this.val);
    }
  }

  class Rad extends Node {
    Rad() {
      type = _type.VAR;
      n_args = 0;
    }
    float getVal(float x, float y) { 
      return dist(x, y, 0, 0);
    }
    String toStr() {
      return "r";
    }
    Node copy() {
      return new Rad();
    }
  }
}

// helper: replace a portion of a with b
DNA _breed(DNA a, DNA b) {
  DNA child = a.copy();
  DNA transplant = getRandomNode(b).copy();
  if (transplant == null) print("\nError: Node is null\n");
  else print("Success getting random node: " + transplant.toStr() + "\n");
  DNA toReplace = getRandomNode(child);
  toReplace.replace(transplant);
  print("child born!!: " + child.toStr() + "\n");
  return child;
}

DNA breed(DNA ma, DNA pa) {
  if (ma.getHeight() <= 1) {
    if (pa.getHeight() <= 1) {
      // no crossbreeding possible
      if (random(1) < 0.5) return ma;
      return pa;
    } else {
      return _breed(pa, ma);
    }
  } else if (pa.getHeight() <= 1) {
    return _breed(ma, pa);
  } else {
    if (random(1) < 0.5) return _breed(ma, pa);
    return _breed(pa, ma);
  }
}

DNA[] breed(DNA ma, DNA pa, int num_children) {
  DNA[] children = new DNA[num_children];
  for (int i = 0; i < num_children; i++) {
    children[i] = breed(ma, pa);
    //mutate
    //TODO:DNA mutant = children[i].mutate(children[i].getHeight());
  }

  return children;
}

// Return a random node (including children)
DNA getRandomNode(DNA tree) {
  int index = (int)random(float(tree.getSize()));
  print("random index: " + index + "\n");
  print("tree size: " + tree.getSize() + "\n");
  //print("random node " + tree.root.getNthNode(-1, index).toStr() + "\n");
  return tree.getNthNode(-1, index);
}

float map4InverseTrig(float x) {
  return 2*(x/(x+1))-1;
}
