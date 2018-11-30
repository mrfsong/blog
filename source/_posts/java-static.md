---
title: 【JAVA回顾】STATIC关键字
date: 2018-04-07 09:31:09
categories: 编程
tags: JAVA
---

{% blockquote %}
STATIC关键字用法&总结
{% endblockquote %}
<!-- more -->


## **初识 static**

static 是 “静态” 的意思，这个大家应该都清楚，静态变量，静态方法大家也都能随口道来。但是，你真的理解静态变量和静态方法么？除了这些 static 还有什么用处？

事实上，static 大体上有五种用法：

> * 静态导入
> * 静态变量
> * 静态方法
> * 静态代码段
> * 静态内部类

接下来，我们将逐个看一下这些用法。

## **静态导入**

也许有的人是第一次听说静态导入，反正我在写这篇文章之前是不清楚 static 还可以这样用的。什么是静态导入呢？我们先来看一段代码：

```
public class OldImport {
    public static void main(String[] args) {
        double a = Math.cos(Math.PI / 2);
        double b = Math.pow(2.4,1.2);

        double r = Math.max(a,b);

        System.out.println(r);
    }
}
```

看到这段代码，你有什么想说的么？啥？没有？你不觉得 Math 出现的次数太多了么？

恩，你觉得好像是有点多，怎么办呢？看下面：

```
import static java.lang.Math.*;

public class StaticImport {
    public static void main(String[] args) {
        double a = cos(PI / 2);
        double b = pow(2.4,1.2);

        double r = max(a,b);

        System.out.println(r);
    }
}
```

这就是静态导入。我们平时使用一个静态方法的时候，都是【类名. 方法名】，使用静态变量的时候都是【类名. 变量名】，如果一段代码中频繁的用到了这个类的方法或者变量，我们就要写好多次类名，比如上面的 Math，这显然不是喜欢偷懒的程序员所希望做的，所以出现了静态导入的功能。

静态导入，就是把一个静态变量或者静态方法一次性导入，导入后可以直接使用该方法或者变量，而不再需要写对象名。

怎么样，是不是觉得很方便？如果你以前不知道这个，你大概在窃喜，以后可以偷懒了。先别高兴的太早，看下面的代码：

```
import static java.lang.Double.*;
import static java.lang.Integer.*;
import static java.lang.Math.*;
import static java.text.NumberFormat.*;

public class ErrorStaticImport {
    // 输入半径和精度要求，计算面积
    public static void main(String[] args) {
        double s = PI * parseDouble(args[0]);
        NumberFormat nf = getInstance();
        nf.setMaximumFractionDigits(parseInt(args[1]));
        formatMessage(nf.format(s));
    }
    // 格式化消息输出
    public static void formatMessage(String s){
        System.out.println(" 圆面积是："+s);
    }
}

```

就这么一段程序，看着就让人火大：常量 PI，这知道，是圆周率；parseDouble 方法可能是 Double 类的一个转换方法，这看名称也能猜测到。那紧接着的 getInstance 方法是哪个类的？是 ErrorStaticImport 本地类的方法？不对呀，没有这个方法，哦，原来是 NumberFormate 类的方法，这和 formateMessage 本地方法没有任何区别了。这代码也太难阅读了，这才几行？要是你以后接别人的代码，看到成千上万行这种代码大概你想死的心都有了吧？

所以，不要滥用静态导入！！！不要滥用静态导入！！！不要滥用静态导入！！！

正确使用静态导入的姿势是什么样子的呢？

```
import java.text.NumberFormat;

import static java.lang.Double.parseDouble;
import static java.lang.Integer.parseInt;
import static java.lang.Math.PI;
import static java.text.NumberFormat.getInstance;

public class ErrorStaticImport {
    // 输入半径和精度要求，计算面积
    public static void main(String[] args) {
        double s = PI * parseDouble(args[0]);
        NumberFormat nf = getInstance();
        nf.setMaximumFractionDigits(parseInt(args[1]));
        formatMessage(nf.format(s));
    }
    // 格式化消息输出
    public static void formatMessage(String s){
        System.out.println(" 圆面积是："+s);
    }
}

```

没错，这才是正确的姿势，你使用哪个方法或者哪个变量，就把他导入进来，而不要使用通配符（*）！

并且，由于不用写类名了，所以难免会和本地方法混淆。所以，本地方法在起名字的时候，一定要起得有意义，让人一看这个方法名大概就能知道你这个方法是干什么的，而不是什么 method1(),method2()，鬼知道你写的是什么。。

> **总结：**
>
> *   不使用 * 通配符，除非是导入静态常量类（只包含常量的类或接口）。
> *   方法名是具有明确、清晰表象意义的工具类。

* * *

> 这里有一个小插曲，就是我在用 idea 写示例代码的时候，想用通配符做静态导入，结果刚写完，idea 自动给我改成非通配符的了，嘿我这暴脾气，我再改成通配符！特喵的。。又给我改回去了。。。事实证明，用一个好的 IDE，是可以提高效率，比呢且优化好你的代码的，有的时候后，想不优化都不行。哈哈哈，推荐大家使用 idea。

## **静态变量**

> 这个想必大家都已经很熟悉了。我就再啰嗦几句。

java 类提供了两种类型的变量：用 static 修饰的静态变量和不用 static 修饰的成员变量。

*   **静态变量**属于类，在内存中只有一个实例。当 jtbl 所在的类被加载的时候，就会为该静态变量分配内存空间，该变量就可以被使用。jtbl 有两种被使用方式：【类名. 变量名】和【对象. 变量名】。

*   **实例变量**属于对象，只有对象被创建后，实例对象才会被分配空间，才能被使用。他在内存中存在多个实例，只能通过【对象. 变量名】来使用。

    > java 的内存大体上有四块：堆，栈，静态区，常量区。
    > 其中的静态区，就是用来放置静态变量的。当静态变量的类被加载时，虚拟机就会在静态区为该变量开辟一块空间。所有使用该静态变量的对象都访问这一个空间。

### **一个例子学习静态变量与实例变量**。

```
public class StaticAttribute {
    public static int staticInt = 10;
    public static int staticIntNo ;
    public int nonStatic = 5;

    public static void main(String[] args) {
        StaticAttribute s = new StaticAttribute();

        System.out.println("s.staticInt= " + s.staticInt);
        System.out.println("StaticAttribute.staticInt= " + StaticAttribute.staticInt);

        System.out.println("s.staticIntNo= " + s.staticIntNo);
        System.out.println("StaticAttribute.staticIntNo= " + StaticAttribute.staticIntNo);

        System.out.println("s.nonStatic= " + s.nonStatic);

        System.out.println("使用s,让三个变量都+1");

        s.staticInt ++;
        s.staticIntNo ++;
        s.nonStatic ++;

        StaticAttribute s2 = new StaticAttribute();

        System.out.println("s2.staticInt= " + s2.staticInt);
        System.out.println("StaticAttribute.staticInt= " + StaticAttribute.staticInt);

        System.out.println("s2.staticIntNo= " + s2.staticIntNo);
        System.out.println("StaticAttribute.staticIntNo= " + StaticAttribute.staticIntNo);

        System.out.println("s2.nonStatic= " + s2.nonStatic);

    }
}
//        结果：
//        s.staticInt= 10
//        StaticAttribute.staticInt= 10
//        s.staticIntNo= 0
//        StaticAttribute.staticIntNo= 0
//        s.nonStatic= 5
//        使用s,让三个变量都+1
//        s2.staticInt= 11
//        StaticAttribute.staticInt= 11
//        s2.staticIntNo= 1
//        StaticAttribute.staticIntNo= 1
//        s2.nonStatic= 5
```

从上例可以看出，静态变量只有一个，被类拥有，所有对象都共享这个静态变量，而实例对象是与具体对象相关的。

> 与 c++ 不同的是，在 java 中，不能在方法体中定义 static 变量，我们之前所说的变量，都是类变量，不包括方法内部的变量。

那么，静态变量有什么用途呢？

### **静态变量的用法**

最开始的代码中有一个静态变量 — PI，也就是圆周率。为什么要把它设计为静态的呢？因为我们可能在程序的任何地方使用到这个变量，如果不是静态的，那么我们每次使用这个变量的时候都要创建一个 Math 对象，不仅代码臃肿而且浪费了内存空间。

所以，当你的某一个变量会经常被外部代码访问的时候，可以考虑设计为静态的。

## **静态方法**

> 同样，静态方法大家应该也比较熟悉了。就是在定义类的时候加一个 static 修饰符。

与静态变量一样，java 类也同时提供了 static 方法和非 static 方法。

*   static 方法是类的方法，不需要创建对象就可以使用，比如 Math 类里面的方法。使用方法【对象. 方法名】或者【类名. 方法名】
*   非 static 方法是对象的方法，只有对象呗创建出来以后才可以被使用。使用方法【对象. 方法名】

> static 怎么用代码写我想大家都知道，这里我就不举例了，你们看着烦，我写着也烦。

### **注意事项**

static 方法中不能使用 this 和 super 关键字，不能调用非 static 方法，只能访问所属类的静态变量和静态方法。因为当 static 方法被调用的时候，这个类的对象可能还没有创建，即使已经被创建了，也无法确认调用那个对象的方法。不能访问非静态方法同理。

### **用途—单例模式**

static 的一个很常见的用途是实现单例模式。单例模式的特点是一个类只能有一个实例，为了实现这一功能，必须隐藏该类的构造函数，即把构造函数声明为 private，并提供一个创建对象的方法。我们来看一下怎么实现：

```
public class Singleton {
    private static Singleton singleton;

    public static Singleton getInstance() {
        if (singleton == null) {
            singleton = new Singleton();
        }
        return singleton;
    }

    private Singleton() {

    }
}
```

这个类，只会有一个对象。

### **其他**

用 public 修饰的 static 成员变量和成员方法本质是全局变量和全局方法，当声明它类的对象时，不生成 static 变量的副本，而是类的所有实例共享同一个 static 变量。

static 变量前可以有 private 修饰，表示这个变量可以在类的静态代码块中，或者类的其他静态成员方法中使用（当然也可以在非静态成员方法中使用–废话），但是不能在其他类中通过类名来直接引用，这一点很重要。

实际上你需要搞明白，private 是访问权限限定，static 表示不要实例化就可以使用，这样就容易理解多了。static 前面加上其它访问权限关键字的效果也以此类推。

### **静态方法的用场**

静态变量可以被非静态方法调用，也可以被静态方法调用。但是静态方法只能被静态方法调用。

一般工具方法会设计为静态方法，比如 Math 类中的所有方法都是惊天的，因为我们不需要 Math 类的实例，我们只是想要用一下里面的方法。所以，你可以写一个通用的 工具类，然后里面的方法都写成静态的。

## **静态代码块**

在讲静态代码块之前，我们先来看一下，什么是代码块。

### **什么是代码块**

所谓代码块就是用大括号将多行代码封装在一起，形成一个独立的数据体，用于实现特定的算法。一般来说代码块是不能单独运行的，它必须要有运行主体。在 Java 中代码块主要分为四种：普通代码块，静态代码块，同步代码块和构造代码块。

### **四种代码块**

*   普通代码块

    > 普通代码块是我们用得最多的也是最普遍的，它就是在方法名后面用 {} 括起来的代码段。普通代码块是不能够单独存在的，它必须要紧跟在方法名后面。同时也必须要使用方法名调用它。

```
    public void common(){
        System.out.println("普通代码块执行");
    }
```

*   静态代码块

    > 静态代码块就是用 static 修饰的用 {} 括起来的代码段，它的主要目的就是对静态属性进行初始化。
    >
    > 静态代码块可以有多个，位置可以随便放，它不在任何的方法体内，JVM 加载类时会执行这些静态的代码块，如果 static 代码块有多个，JVM 将按照它们在类中出现的先后顺序依次执行它们，每个代码块只会被执行一次。

看一段代码：

```
public class Person{
    private Date birthDate;

    public Person(Date birthDate) {
        this.birthDate = birthDate;
    }

    boolean isBornBoomer() {
        Date startDate = Date.valueOf("1990");
        Date endDate = Date.valueOf("1999");
        return birthDate.compareTo(startDate)>=0 && birthDate.compareTo(endDate) < 0;
    }
}
```

　isBornBoomer 是用来这个人是否是 1990-1999 年出生的，而每次 isBornBoomer 被调用的时候，都会生成 startDate 和 birthDate 两个对象，造成了空间浪费，如果改成这样效率会更好：

```
public class Person{
    private Date birthDate;
    private static Date startDate,endDate;
    static{
        startDate = Date.valueOf("1990");
        endDate = Date.valueOf("1999");
    }

    public Person(Date birthDate) {
        this.birthDate = birthDate;
    }

    boolean isBornBoomer() {
        return birthDate.compareTo(startDate)>=0 && birthDate.compareTo(endDate) < 0;
    }
}
```

因此，很多时候会将一些只需要进行一次的初始化操作都放在 static 代码块中进行。

*   同步代码块

    > 使用 synchronized 关键字修饰，并使用 “{}” 括起来的代码片段，它表示同一时间只能有一个线程进入到该方法块中，是一种多线程保护机制。


*   构造代码块

    > 在类中直接定义没有任何修饰符、前缀、后缀的代码块即为构造代码块。我们明白一个类必须至少有一个构造函数，构造函数在生成对象时被调用。构造代码块和构造函数一样同样是在生成一个对象时被调用，那么构造代码在什么时候被调用？如何调用的呢？

看一段代码：

```
public class CodeBlock {
    private int a = 1;
    private int b ;
    private int c ;
    //静态代码块
    static {
        int a = 4;
        System.out.println("我是静态代码块1");
    }
    //构造代码块
    {
        int a = 0;
        b = 2;
        System.out.println("构造代码块1");
    }

    public CodeBlock(){
        this.c = 3;
        System.out.println("构造函数");
    }

    public int add(){

        System.out.println("count a + b + c");
        return a + b + c;
    }
    //静态代码块
    static {
        System.out.println("我是静态代码块2，我什么也不做");
    }
    //构造代码块
    {
        System.out.println("构造代码块2");
    }
    public static void main(String[] args) {
        CodeBlock c = new CodeBlock();
        System.out.println(c.add());

        System.out.println();
        System.out.println("*******再来一次*********");
        System.out.println();

        CodeBlock c1 = new CodeBlock();
        System.out.println(c1.add());
    }
}
//结果：
//我是静态代码块1
//我是静态代码块2，我什么也不做
//构造代码块1
//构造代码块2
//构造函数
//count a + b + c
//6
//
//*******再来一次*********
//
//构造代码块1
//构造代码块2
//构造函数
//count a + b + c
//6
```

这段代码综合了构造代码块，普通代码块和静态代码块。我们来总结一下：

> *   静态代码块只会执行一次。有多个静态代码块时按顺序依次执行。
> *   构造代码块每次创建新对象时都会执行。有多个时依次执行。
> *   执行顺序：静态代码块 > 构造代码块 > 构造函数。
> *   构造代码块和静态代码块有自己的作用域，作用域内部的变量不影响作用域外部。

构造代码块的应用场景：

> 1、 初始化实例变量
> 如果一个类中存在若干个构造函数，这些构造函数都需要对实例变量进行初始化，如果我们直接在构造函数中实例化，必定会产生很多重复代码，繁琐和可读性差。这里我们可以充分利用构造代码块来实现。这是利用编译器会将构造代码块添加到每个构造函数中的特性。
>
> 2、 初始化实例环境
> 一个对象必须在适当的场景下才能存在，如果没有适当的场景，则就需要在创建对象时创建此场景。我们可以利用构造代码块来创建此场景，尤其是该场景的创建过程较为复杂。构造代码会在构造函数之前执行。

## **静态内部类**

被 static 修饰的内部类，它可以不依赖于外部类实例对象而被实例化，而通常的内部类需要在外部类实例化后才能实例化。静态内部类不能与外部类有相同的名字，不能访问外部类的普通成员变量，只能访问内部类中的静态成员和静态方法（包括私有类型）。

由于还没有详细讲解过内部类，这里先一笔带过，在讲解内部类的时候会详细分析静态内部类。

> 只有内部类才能被 static 修饰，普通的类不可以。

## **总结**

本文内容就先到这里，我们再来回顾一下学了什么：

*   static 关键字的五种用法：

    > *   静态导入
    > *   静态变量
    > *   静态方法
    > *   静态代码块
    > *   静态内部类

*   代码块

    > *   普通代码块
    > *   静态代码块
    > *   构造代码块
    > *   同步代码块

回忆一下这些知识点的内容，如果想不起来，记得翻上去再看一遍~

### **彩蛋 —— 继承 + 代码块的执行顺序**

如果既有继承，又有代码块，执行的顺序是怎样呢？

```
public class Parent {
    static {
        System.out.println("父类静态代码块");
    }

    {
        System.out.println("父类构造代码块");
    }

    public Parent(){
        System.out.println("父类构造函数");
    }
}

class Children extends Parent {
    static {
        System.out.println("子类静态代码块");
    }
    {
        System.out.println("子类构造代码块");
    }
    public Children(){
        System.out.println("子类构造函数");
    }

    public static void main(String[] args) {
        new Children();
    }
}

//结果：
//父类静态代码块
//子类静态代码块
//父类构造代码块
//父类构造函数
//子类构造代码块
//子类构造函数
```

结果你也知道了：

> 先执行静态内容 (先父类后子类)，然后执行父类非静态，最后执行子类非静态。（非静态包括构造代码块和构造函数，构造代码块先执行）