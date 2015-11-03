(load "tetris.lisp")
(load "testes-tab.lisp")

(defun estado-0 ()
	(make-estado :pontos 0 :pecas-por-colocar '(o i j l o)
	:pecas-colocadas '() :tabuleiro (cria-tabuleiro))
)

(defun prob-0 ()
	(make-problema :estado-inicial (estado-0))
)

; testes de funcoes auxiliares de problema
(defun preenche-1 ()
	"coloca um i em 0 0"

	(let ((tab (cria-tabuleiro)))

		(coloca tab (first peca-i) 0 0)
))

(defun preenche-2 ()
	"coloca um varios i's deitados no tabuleiro
	e depois uma peca com casas vazias por cima
	objectivo: verificar que casas a NIL na peca nao eliminam pecas no tabuleiro"

	(let ((tab (cria-tabuleiro)))

	(coloca tab (first (rest peca-i)) 0 0)
	(coloca tab (first (rest peca-i)) 0 4)
	(coloca tab (first peca-z) 0 7)
))

(defun preenche (tab peca l c)
	(tabuleiro-preenche-peca! tab peca l c)

	(desenha-estado (make-estado :tabuleiro tab))
)

(defun larga-1 ()
	(larga (cria-tabuleiro) peca-l0 0)
)

(defun larga-u-1 ()
	(let ((tab (copia-tabuleiro (tab-u))))
	(larga tab peca-l0 2)
	(larga tab peca-l0 2)

	(larga tab peca-l0 6)
	(larga tab peca-l2 6)
))

(defun larga-o ()
	(let ((tab (cria-tabuleiro)))
	(larga tab peca-o0 1)
	(larga tab peca-o0 2)
	(larga tab peca-o0 3)

	(larga tab peca-o0 7)
	(larga tab peca-o0 6)
	(larga tab peca-o0 5)
))

(defun larga-tudo ()
	(let ((tab (cria-tabuleiro)))
	(larga tab peca-o0 0)
	(larga tab peca-l0 0)
	(larga tab peca-j0 0)

	(larga tab peca-s0 0)
	(larga tab peca-z0 0)
	(larga tab peca-t0 0)
))

(defun larga (tab peca col)
	(tabuleiro-larga-peca! tab peca col)

	(desenha-estado (make-estado :tabuleiro tab))
)

(defun testa-accoes ()
	(let* ((prob (prob-0))
		(estado (problema-estado-inicial prob)))

	(desenha-estado estado)
	(funcall (problema-accoes prob) estado)
))

(defun testa-resultado-1 ()
	(let* ((prob (prob-0))
		(estado (problema-estado-inicial prob))
		(accoes (funcall (problema-accoes prob) estado)))

	(loop for accao-escolhida in accoes
	do (desenha-estado (funcall (problema-resultado prob)
		estado accao-escolhida)))

	(format t "~a ~%" accoes)
))

(defun testa-resultado-2 ()
	(let* ((prob (prob-0))
		(estado (problema-estado-inicial prob))
		(accao (first (funcall (problema-accoes prob) estado))))

	(loop while accao
	do (progn
		(setf estado (funcall (problema-resultado prob) estado accao))
		(setf accao (first (funcall (problema-accoes prob) estado)))

		(desenha-estado estado)))
))

(defun testa-remove-linha-1 ()
	(let* ((prob (prob-0))
	(estado (problema-estado-inicial prob)))

	(setf (estado-pecas-por-colocar estado) '(o o o o o o o o o o))

	(loop for i in '(0 2 4 6 0 2 4 6 8 8)
	do (progn
		(setf estado (funcall (problema-resultado prob) estado
			(cria-accao i peca-o0)))
	(desenha-estado estado)))
))

(defun testa-fim-jogo ()
	"vai metendo pecas no mesmo sitio ate atingir topo do tabuleiro"
	(let* ((prob (prob-0))
		(estado (copia-estado (problema-estado-inicial prob)))
		(accao (first (funcall (problema-accoes prob) estado))))

		(desenha-estado estado)

		; FIXME: o gajo esta a meter um quadrado, nao sei pq !!!
		(setf (estado-pecas-por-colocar estado) '(l l l l l l l l l l l l l))

	(loop while accao
	do (progn
		(setf estado (funcall (problema-resultado prob) estado accao))
		(setf accao (first (funcall (problema-accoes prob) estado)))

		(format t "pecas por colocar: ~a ~%" (estado-pecas-por-colocar estado))
		(desenha-estado estado)))
))


