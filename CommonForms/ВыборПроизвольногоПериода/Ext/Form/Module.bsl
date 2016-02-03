﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НачалоПериода = Параметры.НачалоПериода;
	КонецПериода  = Параметры.КонецПериода;
	ИмяЭлемента   = Параметры.ИмяЭлемента;
	
	Если НЕ ЗначениеЗаполнено(НачалоПериода) Тогда
		НачалоПериода = ФункцииОтчетовКлиентСервер.НачалоПериодаОтчета(Параметры.МинимальныйПериод, ТекущаяДатаСеанса());
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		КонецПериода  = ФункцииОтчетовКлиентСервер.КонецПериодаОтчета(Параметры.МинимальныйПериод, ТекущаяДатаСеанса());
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	Если НачалоПериода > КонецПериода Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Дата начала периода больше чем дата окончания периода'"), , "НачалоПериода");
		Возврат;
	КонецЕсли;
	
	РезультатВыбора = Новый Структура("НачалоПериода, КонецПериода, ИмяЭлемента");
	ЗаполнитьЗначенияСвойств(РезультатВыбора, ЭтотОбъект);
	
	ОповеститьОВыборе(РезультатВыбора);
КонецПроцедуры

#КонецОбласти
