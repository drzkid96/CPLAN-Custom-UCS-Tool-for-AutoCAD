;;; CPLAN.lsp
;;; Pick a UCS by origin + X-axis direction, locked to top (XY plane only).
;;; Z always stays vertical, so the result is plan/top - never tilted. The
;;; UCS X axis is rotated in plane to your two picks. Then restores the prior
;;; zoom scale centered on the previous view.
;;; During the picks OSMODE is forced to Nearest only, then restored.
;;; Usage: load via APPLOAD, then type CPLAN

(defun c:CPLAN (/ ce os oserr p1 p2 ang vctr vh)

  (setq ce (getvar "CMDECHO")
        os (getvar "OSMODE"))

  (setq oserr *error*)
  (defun *error* (msg)
    (if (and msg (not (wcmatch (strcase msg) "*CANCEL*,*QUIT*")))
      (princ (strcat "\nError: " msg)))
    (setvar "CMDECHO" ce)
    (setvar "OSMODE" os)
    (setq *error* oserr)
    (princ))

  ;; Capture current view BEFORE changing UCS.
  (setq vctr (trans (getvar "VIEWCTR") 1 0)
        vh   (getvar "VIEWSIZE"))

  (setvar "OSMODE" 512)   ;; Nearest only during picks
  (setvar "CMDECHO" 1)

  (if (and (setq p1 (getpoint "\nNew UCS origin: "))
           (setq p2 (getpoint p1 "\nPoint on positive X axis: ")))
    (progn
      (setvar "OSMODE" os)   ;; restore prior osnaps before any further work
      (setvar "CMDECHO" 0)
      ;; Work in WCS, drop Z so UCS can never tilt off top.
      (setq p1  (trans p1 1 0)
            p2  (trans p2 1 0)
            ang (* (/ (angle (list (car p1) (cadr p1) 0.0)
                             (list (car p2) (cadr p2) 0.0))
                      pi) 180.0))
      (command "_.UCS" "_World")                 ;; reset to true top
      (command "_.UCS" "_Origin" (list (car p1) (cadr p1) 0.0))
      (command "_.UCS" "_Z" ang)                 ;; rotate X in plane only
      (command "_.PLAN" "_C")
      (command "_.ZOOM" "_C" (trans vctr 0 1) vh)
      (command "_.REGEN")
      (princ "\nTop-locked UCS set, plan view applied, prior zoom restored."))
    (princ "\nCancelled - origin and X-axis point required."))

  (setvar "CMDECHO" ce)
  (setvar "OSMODE" os)
  (setq *error* oserr)
  (princ))

(princ "\nCPLAN loaded. Type CPLAN to run.")
(princ)
