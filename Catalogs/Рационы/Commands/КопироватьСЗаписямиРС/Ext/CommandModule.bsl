﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	//Запрос = Новый Запрос;
	//	Запрос.Текст = 
	//		"ВЫБРАТЬ
	//		|	&НовыйРацион,
	//		|	СоставРациона.Продукт,
	//		|	СоставРациона.ПриемПищи,
	//		|	СоставРациона.ЕдИзм,
	//		|	СоставРациона.Количество,
	//		|	СоставРациона.КоличествоЕдИзм
	//		|ИЗ
	//		|	РегистрСведений.СоставРациона КАК СоставРациона
	//		|ГДЕ
	//		|	СоставРациона.Рацион = &Рацион";
	//	
	//	Запрос.УстановитьПараметр("Рацион", ИсточникКопирования);
	//	Запрос.УстановитьПараметр("НовыйРацион", НоваяСсылка);
	//	
	//	РезультатЗапроса = Запрос.Выполнить(); 		
	//
	//    Набор = РегистрыСведений.СоставРациона.СоздатьНаборЗаписей();
	//	Набор.Отбор.Рацион.Установить(НоваяСсылка);
	//	Набор.Загрузить(РезультатЗапроса.Выгрузить());
	//	Набор.Записать();
	
КонецПроцедуры
