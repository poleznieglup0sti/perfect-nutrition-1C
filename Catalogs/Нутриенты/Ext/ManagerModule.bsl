﻿Функция ПолучитьКоэффициентПересчетаМЕ_в_мкг(Нутриент) Экспорт
	
	Результат = 1;
	
	Если Нутриент = Справочники.Нутриенты.ВитаминD Тогда  		
		Результат = 0.0250;
	ИначеЕсли Нутриент = Справочники.Нутриенты.ВитаминE Тогда 
		Результат = 666.6667;
	ИначеЕсли Нутриент = Справочники.Нутриенты.ВитаминA Тогда 
		Результат = 0.3;
	ИначеЕсли Нутриент = Справочники.Нутриенты.ВитаминC Тогда 
		Результат = 50;
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции
 