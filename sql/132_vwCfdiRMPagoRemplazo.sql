SELECT     pag.DOCNUMBR AS Expr3, pag.DEX_ROW_ID AS Expr73, pag.RMDTYPAL, pag.NOTEINDX, rem.TXTFIELD
FROM         dbo.RM20101 AS pag INNER JOIN
                      dbo.SY03900 AS rem ON rem.NOTEINDX = pag.NOTEINDX
WHERE     (pag.RMDTYPAL = 9)