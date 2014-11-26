function result=SynthesizeFeature(F0,F1,F2,F3,F4,F5,F6,F7)
%定义合成适配特征表达式
%运算关系定义
%    双目操作
%      Operation0  ADD_AB
%      Operation1  SUB_AB
%      Operation2  MUL_AB
%      Operation3  DIV_AB
%      Operation4  MAX_AB
%      Operation5  MIN_AB
%    单目操作
%      Operation6  ADDC
%      Operation7  SUBC
%      Operation8  MULC
%      Operation9  DIVC
%      Operation10  Sqrt
%      Operation11  Log10
%      Operation12  Inverse
%      Operation13  Oppsition

%特征1
   result=Op12(Op5(Op12(F3),Op3(Op3(Op3(Op3(Op2(Op12(Op12(F5)),Op13(F7)),Op8(F7)),Op1(Op0(Op8(Op1(Op8(Op9(F0)),Op2(Op8(F2),Op10(F1)))),Op12(F5)),Op12(F5))),Op12(F5)),Op12(F5))));          
%特征2
%    result=Op11(Op6(Op0(Op1(Op13(F5),Op11(Op4(Op6(Op4(Op7(F2),Op4(Op9(Op6(F0)),Op4(Op8(F2),Op8(F2))))),Op8(F2)))),Op3(Op11(Op4(Op10(F7),Op8(F2))),Op11(Op10(F7))))));
return ;