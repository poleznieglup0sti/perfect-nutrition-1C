﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Предмет") Тогда 
		Предмет = Параметры.Предмет;
		Список.Параметры.УстановитьЗначениеПараметра("Предмет", Предмет);
	КонецЕсли;	
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", Пользователи.ТекущийПользователь());
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьЗаметкиДругихПользователей", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьУдаленные", Ложь);
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьЗаметкиДругихПользователей", ПоказыватьЗаметкиДругихПользователей);
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьУдаленные", ПоказыватьУдаленные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьЗаметкиДругихПользователейПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьЗаметкиДругихПользователей", ПоказыватьЗаметкиДругихПользователей);
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленныеПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьУдаленные", ПоказыватьУдаленные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыСписок
&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	ПараметрыФормы = Новый Структура("Предмет", Предмет);
	ОткрытьФорму("Справочник.Заметки.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти
