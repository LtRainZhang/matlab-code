#coding = utf-8
# matlab-code
%%%%%%%%%%%一
用Matlab实现字符串分割（split）
Posted on 2011/08/08 

Matlab的字符串处理没有C#强大，本身又没有提供OO特性，需要依赖别的手段完成这项任务。

我们在这里借助正则表达式函数regexp的split模式。一般语法：
S = regexp(str, char, 'split')

其中str是待分割的字符串，char是作为分隔符的字符（可以使用正则表达式）。分割出的结果存在S中。

以下面这样一串字符为例
Hello Nocturne Studio
首先去除首尾的多余空格：
str = deblank(str)

例1：设这几个字符串是以制表符分隔的，可以这样来做：
S = regexp(str, '\t', 'split')

例2：设这些字符串是以一个或多个空格分隔的，可以用正则表达式来描述：
S = regexp(str, '\s+', 'split')

这样，S(1)=’Hello’，S(2)=’Nocturne’，S(3)=’Studio’。

%%%%%%%%%%%%%%二
num2str数字转化为字符串保留小数的方法 :
num2str(2.10,'%4.2f')>>>其中.2表示小数点保留多少位
