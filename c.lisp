; 导入包
(require libtable)

; 定义斐波那契函数
(var fib 
    (lambda (n) 
        (if (< n 2) 
            1 
            (+ 
                (fib 
                    (- n 1)
                ) 
                (fib 
                    (- n 2)
                )
            )
        )
    )
)


