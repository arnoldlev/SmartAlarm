import 'dart:math';

class Puzzle {

  late int op1;
  late int op2;

  Puzzle() {
    op1 = Random().nextInt(100) + 1;
    op2 = Random().nextInt(100) + 1;
  }

  int getOp1() {
    return op1;
  }

  int getOp2() {
    return op2;
  }

  int getAnswer() {
    return op1 + op2;
  }


}