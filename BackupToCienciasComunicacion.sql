http://www.orafaq.com/wiki/Import_Export_FAQ

categoria
	- codigo_categoria
	- nombre

/*delete*/
delete from movimiento;
delete from detalle_movimiento;
delete from categoria;
delete from producto;
delete from reglon;
delete from medida;
/*codigo_categoria, codigo_linea,(266) codigo_reglon(41), nombre, codigo_producto, codigo_medida(35)*/
delete  from producto_bodega
/*codigo_producto, codigo_bodega(1), codigo_area(4), existencia, precio, saldo ,kardex*/
/*------- inserts -------*/
/*medida*/
insert into medida (nombre) 
	select distinct medida
		from last_import 
		where medida is not null;
/*reglon*/
insert into reglon (nombre) 
	select distinct renglon
		from last_import 
		where renglon is not null;
/*categoria*/
insert into categoria (nombre) 
	select distinct clasificacion 
		from last_import 
		where clasificacion is not null;
/*linea*/
insert into linea (nombre,codigo_categoria)
  select categoria.nombre, categoria.codigo_categoria
    from categoria;
/*producto*/
insert into producto (codigo_categoria, codigo_linea, codigo_reglon, nombre, codigo_producto, codigo_medida)
	select c.codigo_categoria,line.codigo_linea,r.codigo_reglon,l.producto,l.codigo,m.codigo_medida
		from categoria c, last_import l, linea line, medida m, reglon r
		where c.nombre = l.clasificacion 
      and c.codigo_categoria = line.codigo_categoria
      and m.nombre = l.medida
      and r.nombre = l.renglon;
/*producto_bodega*/
insert into producto_bodega (codigo_producto, codigo_bodega, codigo_area, existencia, precio,saldo,kardex)
	select l.codigo,1,4, l.existencia, l.precio, l.saldo, l.tarjeta
		from last_import l;
    
/*tipo_movimiento*/
insert into tipo_movimiento
  values (null, 'INGRESO INICIAL','IMPORT SALDOS INICIALES',1);		

insert into movimiento 
  (id_movimiento,fecha_emision, codigo_tipo_movimiento)
  values (1,sysdate,4);		
  
insert into detalle_movimiento
  (codigo_movimiento,codigo_producto,codigo_bodega,
      costo_unitario,cantidad_solicitada, costo_total, codigo_area,
      existencia, saldo, precio_promedio,cantidad_despachada)
  select 1,codigo_producto,codigo_bodega,
      precio,existencia,saldo,codigo_area,
      existencia, saldo, precio, existencia 
  from producto_bodega;
  
  
  /*repeats*/
  SELECT codigo, 
 COUNT(codigo) 
FROM last_import
GROUP BY codigo
HAVING ( COUNT(codigo) > 1 );

select * from last_import where existencia = '0';