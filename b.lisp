; 导入封装的相关包
(require libtable)

; 定义一个工厂函数，参数接受一个函数，返回一个新的函数
; 作用：将传入函数的参数 d 固定为 "world"
(var create
    (lambda (b)
        (part b "d" "world") ;part 函数 类似python的 偏函数 的作用
    )
)

; 测试函数，用于打印两个参数，c和d
(var test
    (lambda (c) (print c d))
)

; 接受新的函数 res
(var res (create "test"))

; 调用res，只提供第一个参数
(res "hello,")

; 输入 hello,  world