USE [MC1_Test]
GO
--|Criando Tabela|--
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS(SELECT * FROM SYS.TABLES WHERE NAME = 'PEDIDOS')
Begin 
  Drop Table [dbo].[Pedidos]
end
go
CREATE TABLE [dbo].[Pedidos](
	[dt] [datetime] NULL,
	[customer] [varchar](64) NULL,
	[type] [varchar](4) NULL,
	[amount] [decimal](4, 2) NULL,
	[status] [varchar](9) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Pedidos] ADD  CONSTRAINT [DF_Pedidos_dt]  DEFAULT (getdate()) FOR [dt]
GO
--|Popolando Tabela|--
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'rclaypole0@qq.com', 'BUY', 71.46, 'CANCELED'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'asmithin4@elegantthemes.com', 'SELL', 40.24, 'CANCELED'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'rclaypole0@qq.com', 'SELL', 69.35, 'PENDING'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'rclaypole0@qq.com', 'SELL', 3.37, 'CANCELED'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'bhaddeston2@mapquest.com', 'BUY', 15.46, 'CANCELED'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'bhaddeston2@mapquest.com', 'SELL', 90.16, 'COMPLETED'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'rclaypole0@qq.com', 'BUY', 53.40, 'CANCELED'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'bhaddeston2@mapquest.com', 'SELL', 6.48, 'PENDING'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'stapenden1@google.de', 'SELL', 72.67, 'PENDING'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT  'stapenden1@google.de','BUY', 93.29, 'CANCELED'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT  'rclaypole0@qq.com', 'BUY', 53.19, 'PENDING'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'rclaypole0@qq.com', 'BUY', 51.17, 'CANCELED'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'bhaddeston2@mapquest.com', 'SELL', 10.57,'PENDING'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'rclaypole0@qq.com', 'BUY',68.25,'COMPLETED'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'rclaypole0@qq.com', 'SELL',66.78,'PENDING'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'gnickerson3@globo.com', 'BUY',26.31,'PENDING'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'bhaddeston2@mapquest.com','BUY',86.05, 'CANCELED'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'stapenden1@google.de','SELL', 31.49,'CANCELED'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'bhaddeston2@mapquest.com','BUY',50.93,'PENDING'
	INSERT INTO [dbo].[Pedidos] ([customer],[type],[amount],[status]) SELECT 'stapenden1@google.de','BUY',5.40,'CANCELED'
 
--|Montando Query


	Select Customer, Sum(Buy_total) Buy, Sum(Sell_Total) Sell, (Sum(Buy_total)  +  Sum(Sell_Total) ) total
	From (

	Select Customer, (Sum(Canceled) + Sum(Completed)) Buy_Total, 0 Sell_Total
	from (
		SELECT 
			Customer
			,CANCELED = isnull(case status when 'CANCELED' then sum(round( (amount-(amount*0.01)), 2) ) end, 0) 
			,COMPLETED= isnull(case status when 'COMPLETED' then sum(round( amount, 2) ) end,0) 
		FROM Pedidos (nolock)
		where type = 'Buy' and Status not in ('PENDING')
		group by customer, status
		) rs
	Group By Customer
    union all
	Select Customer, 0 Buy_Total,  (Sum(Canceled) + Sum(Completed)) Sell_Total 
	from (
		SELECT 
			Customer
			,CANCELED = isnull(case status when 'CANCELED' then sum(round( (amount-(amount*0.01)), 2) ) end, 0) 
			,COMPLETED= isnull(case status when 'COMPLETED' then sum(round( amount, 2) ) end,0) 
		FROM Pedidos (nolock)
		where type = 'Sell' and Status not in ('PENDING')
		group by customer, status
		) rs
	Group By Customer
	) dados
	Group By Customer