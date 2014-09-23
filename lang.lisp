;;;;; Caroshi – Copyright (c) 2010–2014 Sven Michael Klose <pixel@copei.de>

(defvar *current-language* 'en)
(defvar *fallback-language* 'en)
(defvar *available-languages* '(en))

(defmacro lang (&rest args)
  (? (== 2 (length args))
	 .args.
  	 (with (defs (group args 2)
		 	default (assoc *fallback-language* defs))
  	   `(case *current-language* :test #'eq
		    ,@(mapcan [. (list 'quote _.) ._] (remove default defs))
		    ,.default.))))

(defmacro singular-plural (num consequence fallback)
  `(? (== 1 ,num)
	  ,consequence
	  ,fallback))

(defun switch-language (to)
  (= *current-language* (| (find to *available-languages*)
                           *fallback-language*)))
