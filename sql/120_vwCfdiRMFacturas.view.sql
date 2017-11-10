USE [MEX10]
GO

/****** Object:  View [dbo].[vwCfdiRMFacturas]    Script Date: 11/09/2017 21:21:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwCfdiRMFacturas]
AS
SELECT     d .ORTRXAMT AS Monto, cuf.ISOCURRC AS MonedaDR, CASE WHEN cup.isocurrc = cuf.isocurrc THEN NULL 
                      ELSE CASE WHEN cuf.ISOCURRC = 'MXN' THEN 1 ELSE a.oraptoam / a.apptoamt END END TipoCambioDR, CASE WHEN LEFT(UPPER(d .TRXDSCRN), 1) = 'C' AND 
                      isnumeric(substring(d .TRXDSCRN, 2, 2)) = 1 THEN CAST(substring(D .TRXDSCRN, 2, 2) AS int) ELSE pcm.numCuota END NumParcialidad, 
                      F.ORTRXAMT - pcm.sumaDePagosAplicados + a.oraptoam ImpSaldoAnt, a.ORAPTOAM AS ImpPagado, F.ORTRXAMT - pcm.sumaDePagosAplicados ImpSaldoInsoluto, 
                      d .DOCNUMBR, a.APTODCNM, d .TRXDSCRN, d .RMDTYPAL, d .VOIDSTTS, uf.uuid AS IdDocumento,a.oraptoam,a.apptoamt
FROM         dbo.vwRmTransaccionesTodas AS d INNER JOIN
                      dbo.vwCfdiRmTrxAplicadas AS a ON d .RMDTYPAL = a.APFRDCTY AND d .DOCNUMBR = a.APFRDCNM LEFT JOIN
                      dbo.vwRmTransaccionesTodas AS F ON F.RMDTYPAL = a.APTODCTY AND F.DOCNUMBR = a.APTODCNM AND F.voidstts = 0 LEFT OUTER JOIN
                      DYNAMICS.dbo.MC40200 AS cup ON cup.CURNCYID = d .CURNCYID LEFT OUTER JOIN
                      DYNAMICS.dbo.MC40200 AS cuf ON cuf.CURNCYID = F.CURNCYID OUTER apply dbo.fCfdiParametros('VERSION', 'NA', 'NA', 'NA', 'NA', 'NA', 'PREDETERMINADO') 
                      pa OUTER apply dbo.fCfdiParametrosCliente(d .CUSTNMBR, 'ResidenciaFiscal', 'NumRegIdTrib', 'NA', 'NA', 'NA', 'NA', 'PREDETERMINADO') pac OUTER 
                      apply dbo.fCfdiObtieneUUID(CASE WHEN f.soptype = 0 THEN a.aptodcty ELSE f.soptype END, a.APTODCNM) uf OUTER 
                      apply dbo.fCfdiPagosAcumulados(a.APFRDCTY, a.APFRDCNM, a.APFRDCDT, a.APTODCTY, a.APTODCNM, d .TRXDSCRN) pcm

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[66] 3) )"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 5
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = -192
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 23
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1770
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCfdiRMFacturas'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCfdiRMFacturas'
GO


