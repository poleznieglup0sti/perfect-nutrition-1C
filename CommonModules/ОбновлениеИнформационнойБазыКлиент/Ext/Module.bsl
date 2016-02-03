﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление версии ИБ"
// Клиентские процедуры и функции для интерактивного обновления информационной базы.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// См. описание параметра ПриЗапускеКлиентскогоПриложения в модуле ОбновлениеИнформационнойБазы
// в описании функции ВыполнитьОбновлениеИнформационнойБазы.
//
Процедура ОбновитьИнформационнуюБазу(Параметры) Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если НЕ ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		ЗакрытьФормуИндикацииХодаОбновленияЕслиОткрыта(Параметры);
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРаботыКлиента.Свойство("НеобходимоОбновлениеИнформационнойБазы") Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"НачатьОбновлениеИнформационнойБазы", ЭтотОбъект);
	Иначе
		Если ПараметрыРаботыКлиента.Свойство("ЗагрузитьСообщениеОбменаДанными") Тогда
			Перезапустить = Ложь;
			ОбновлениеИнформационнойБазыВызовСервера.ВыполнитьОбновлениеИнформационнойБазы(, Истина, Перезапустить);
			Если Перезапустить Тогда
				Параметры.Отказ = Истина;
				Параметры.Перезапустить = Истина;
			КонецЕсли;
		КонецЕсли;
		ЗакрытьФормуИндикацииХодаОбновленияЕслиОткрыта(Параметры);
	КонецЕсли;
	
КонецПроцедуры

// Для процедуры ОбновитьИнформационнуюБазу.
Процедура ЗакрытьФормуИндикацииХодаОбновленияЕслиОткрыта(Параметры)
	
	Если Параметры.Свойство("ФормаИндикацияХодаОбновленияИБ") Тогда
		Если Параметры.ФормаИндикацияХодаОбновленияИБ.Открыта() Тогда
			Параметры.ФормаИндикацияХодаОбновленияИБ.НачатьЗакрытие();
		КонецЕсли;
		Параметры.Удалить("ФормаИндикацияХодаОбновленияИБ");
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры ОбновитьИнформационнуюБазу.
Процедура НачатьОбновлениеИнформационнойБазы(Параметры, ОбработкаПродолжения) Экспорт
	
	Если Параметры.Свойство("ФормаИндикацияХодаОбновленияИБ") Тогда
		Форма = Параметры.ФормаИндикацияХодаОбновленияИБ;
	Иначе
		ИмяФормы = "Обработка.ОбновлениеИнформационнойБазы.Форма.ИндикацияХодаОбновленияИБ";
		
		Форма = ОткрытьФорму(ИмяФормы,,,,,, Новый ОписаниеОповещения(
			"ПослеЗакрытияФормыИндикацияХодаОбновленияИБ", ЭтотОбъект, Параметры));
		
		Параметры.Вставить("ФормаИндикацияХодаОбновленияИБ", Форма);
	КонецЕсли;
	
	Форма.ОбновитьИнформационнуюБазу();
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры ПередНачаломРаботыПрограммы.
Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммы(Параметры, Неопределен) Экспорт
	
	ИмяФормы = "Обработка.ОбновлениеИнформационнойБазы.Форма.ИндикацияХодаОбновленияИБ";
	
	Форма = ОткрытьФорму(ИмяФормы,,,,,, Новый ОписаниеОповещения(
		"ПослеЗакрытияФормыИндикацияХодаОбновленияИБ", ЭтотОбъект, Параметры));
	
	Параметры.Вставить("ФормаИндикацияХодаОбновленияИБ", Форма);
	
	Форма.ЗагрузитьОбновитьПараметрыРаботыПрограммы(Параметры);
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры ОбновитьИнформационнуюБазу
Процедура ПослеЗакрытияФормыИндикацияХодаОбновленияИБ(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Результат = Новый Структура("Отказ, Перезапустить", Истина, Ложь);
	КонецЕсли;
	
	Если Результат.Отказ Тогда
		Параметры.Отказ = Истина;
		Если Результат.Перезапустить Тогда
			Параметры.Перезапустить = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

// Если есть непоказанные описания изменения и у пользователя не отключен
// показ - открыть форму ОписаниеИзмененийСистемы.
//
Процедура ПоказатьОписаниеИзмененийСистемы()
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиента.ПоказатьОписаниеИзмененийСистемы Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ПоказыватьТолькоИзменения", Истина);
		
		ОткрытьФорму("ОбщаяФорма.ОписаниеИзмененийСистемы", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

// Выводит оповещение пользователю о том, что отложенная обработка данных
// не выполнена.
//
Процедура ОповеститьОтложенныеОбработчикиНеВыполнены() Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Работа в программе временно ограничена'"),
		НавигационнаяСсылкаОбработки(),
		НСтр("ru = 'Не завершен переход на новую версию'"),
		БиблиотекаКартинок.Предупреждение32);
	
КонецПроцедуры

// Возвращает навигационную ссылку обработки ОбновлениеИнформационнойБазы.
//
Функция НавигационнаяСсылкаОбработки()
	Возврат "e1cib/app/Обработка.ОбновлениеИнформационнойБазы";
КонецФункции

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
// Вызывается после завершения действий ПриНачалеРаботыСистемы.
// Используется для подключения обработчиков ожидания, которые не должны вызываться
// в случае интерактивных действий перед и при начале работы системы.
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыКлиента.Свойство("ПоказатьСообщениеОбОшибочныхОбработчиках")
		Или ПараметрыКлиента.Свойство("ПоказатьОповещениеОНевыполненныхОбработчиках") Тогда
		ПодключитьОбработчикОжидания("ПроверитьСтатусОтложенногоОбновления", 2, Истина);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Вызывается перед интерактивным началом работы пользователя с областью данных.
// Соответствует событию ПередНачаломРаботыСистемы модулей приложения.
//
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыКлиента.Свойство("ИнформационнаяБазаЗаблокированаДляОбновления") Тогда
		Параметры.Отказ = Истина;
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"ПоказатьПредупреждениеИПродолжить",
			СтандартныеПодсистемыКлиент.ЭтотОбъект,
			ПараметрыКлиента.ИнформационнаяБазаЗаблокированаДляОбновления);
		
	ИначеЕсли ПараметрыКлиента.Свойство("НеобходимоОбновлениеПараметровРаботыПрограммы") Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"ЗагрузитьОбновитьПараметрыРаботыПрограммы", ЭтотОбъект, Параметры);
		
	ИначеЕсли Найти(НРег(ПараметрЗапуска), НРег("ЗарегистрироватьПолноеИзменениеИОМДляПодчиненныхУзловРИБ")) > 0 Тогда
		Параметры.Отказ = Истина;
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"ПоказатьПредупреждениеИПродолжить",
			СтандартныеПодсистемыКлиент.ЭтотОбъект,
			НСтр("ru = 'Параметр запуска ЗарегистрироватьПолноеИзменениеИОМДляПодчиненныхУзловРИБ
			           |можно использовать только совместно с параметром ЗапуститьОбновлениеИнформационнойБазы.'"));
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при интерактивном начале работы пользователя с областью данных.
// Соответствует событию ПриНачалеРаботыСистемы модулей приложения.
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если НЕ ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОписаниеИзмененийСистемы();
	
КонецПроцедуры

#КонецОбласти
