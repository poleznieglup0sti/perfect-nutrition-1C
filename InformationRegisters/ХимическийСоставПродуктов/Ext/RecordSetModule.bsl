﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	ТаблицаНутриентов = ЭтотОбъект.Выгрузить();
	ТаблицаНутриентов.Свернуть("Продукт, Нутриент", "Количество, МинКоличество, МаксКоличество");
	ЭтотОбъект.Загрузить(ТаблицаНутриентов);
	
КонецПроцедуры
