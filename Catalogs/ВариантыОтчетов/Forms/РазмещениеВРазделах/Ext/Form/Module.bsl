﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление();
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СмешаннаяВажность = НСтр("ru = 'Различная'");
	
	// Контроль количества вариантов осуществляется до открытия формы
	ИзменяемыеВарианты.ЗагрузитьЗначения(Параметры.МассивВариантов);
	
	ПерезаполнитьДерево(Ложь);
	
	ВариантыОтчетов.ДеревоПодсистемДобавитьУсловноеОформление(ЭтотОбъект);
	
	ТекущийЭлемент = Элементы.ДеревоПодсистем;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если РезультатВыполнения <> Неопределено Тогда
		Если РезультатВыполнения.Свойство("Отказ") И РезультатВыполнения.Отказ = Истина Тогда
			Отказ = Истина;
			ПоказатьРезультатВыполнения();
		Иначе
			ПодключитьОбработчикОжидания("ПоказатьРезультатВыполнения", 0.2, Истина);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИзменяемыеВариантыПриИзменении(Элемент)
	ПерезаполнитьДерево(Ложь);
	ПоказатьРезультатВыполнения();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПодсистем

&НаКлиенте
Процедура ДеревоПодсистемИспользованиеПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемИспользованиеПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемВажностьПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемВажностьПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Разместить(Команда)
	Если ПроверитьКоличествоВариантов() Тогда
		ЗаписатьНаСервере();
		ТекстОповещения = НСтр("ru = 'Изменены настройки вариантов отчетов (%1 шт.).'");
		ТекстОповещения = СтрЗаменить(ТекстОповещения, "%1", Формат(ИзменяемыеВарианты.Количество(), "ЧН=0; ЧГ=0"));
		ПоказатьОповещениеПользователя(, , ТекстОповещения);
		ВариантыОтчетовКлиент.ОбновитьОткрытыеФормы();
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Перечитать(Команда)
	Если ПроверитьКоличествоВариантов() Тогда
		ПерезаполнитьДерево(Ложь);
		Элементы.ДеревоПодсистем.Развернуть(ДеревоПодсистем.ПолучитьЭлементы()[0].ПолучитьИдентификатор(), Истина);
		ПоказатьРезультатВыполнения();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	Если ПроверитьКоличествоВариантов() Тогда
		ПерезаполнитьДерево(Истина);
		Элементы.ДеревоПодсистем.Развернуть(ДеревоПодсистем.ПолучитьЭлементы()[0].ПолучитьИдентификатор(), Истина);
		ПоказатьРезультатВыполнения();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	Инструкция = ВариантыОтчетов.ИнструкцияУсловногоОформления();
	Инструкция.Поля = "ДеревоПодсистемВажность";
	Инструкция.Отборы.Вставить("ДеревоПодсистем.Важность", Новый ПолеКомпоновкиДанных("СмешаннаяВажность"));
	Инструкция.Оформление.Вставить("ЦветТекста", ЦветаСтиля.ЗаблокированныйРеквизитЦвет);
	ВариантыОтчетов.ДобавитьЭлементУсловногоОформления(ЭтотОбъект, Инструкция);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Функция ПроверитьКоличествоВариантов()
	ОчиститьСообщения();
	Если КоличествоВариантов = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Необходимо заполнить список ""Варианты отчетов""'"),
			,
			"ИзменяемыеВарианты");
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура ПоказатьРезультатВыполнения()
	ОчиститьСообщения();
	Если РезультатВыполнения <> Неопределено Тогда
		СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтотОбъект, РезультатВыполнения);
		РезультатВыполнения = Неопределено;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Процедура ПерезаполнитьДерево(ТолькоСнятьФлажки)
	
	Если ТолькоСнятьФлажки = Истина Тогда
		ДеревоПриемник = РеквизитФормыВЗначение("ДеревоПодсистем", Тип("ДеревоЗначений"));
		Найденные = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Использование", 1), Истина);
		Для Каждого СтрокаДерева Из Найденные Цикл
			СтрокаДерева.Использование = 0;
			Если СтрокаДерева.Использование <> СтрокаДерева.ИспользованиеПоУмолчанию Тогда
				СтрокаДерева.ИзмененПользователем = Истина;
			КонецЕсли;
		КонецЦикла; 
		
		Найденные = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Использование", 2), Истина);
		Для Каждого СтрокаДерева Из Найденные Цикл
			СтрокаДерева.Использование = 0;
			Если СтрокаДерева.Использование <> СтрокаДерева.ИспользованиеПоУмолчанию Тогда
				СтрокаДерева.ИзмененПользователем = Истина;
			КонецЕсли;
		КонецЦикла; 
		
		ЗначениеВРеквизитФормы(ДеревоПриемник, "ДеревоПодсистем");
		Возврат;
	КонецЕсли;
	
	КоличествоВариантов = ИзменяемыеВарианты.Количество();
	Если КоличествоВариантов = 0 Тогда
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("ВыводСообщения", Новый Структура("Использование, Текст, ПутьКРеквизитуФормы", Истина));
		РезультатВыполнения.ВыводСообщения.Текст = НСтр("ru = 'Необходимо добавить указать варианты отчетов'");
		РезультатВыполнения.ВыводСообщения.ПутьКРеквизитуФормы = "";
		РезультатВыполнения = Новый ФиксированнаяСтруктура(РезультатВыполнения);
		Элементы.ДеревоПодсистем.Доступность = Ложь;
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВариантыОтчетов.Ссылка,
	|	ВариантыОтчетов.ПредопределенныйВариант,
	|	ВЫБОР
	|		КОГДА ВариантыОтчетов.ПометкаУдаления
	|			ТОГДА 1
	|		КОГДА &ПолныеПраваНаВарианты = ЛОЖЬ
	|				И ВариантыОтчетов.Автор <> &ТекущийПользователь
	|			ТОГДА 2
	|		КОГДА НЕ ВариантыОтчетов.Отчет В (&ОтчетыПользователя)
	|			ТОГДА 3
	|		КОГДА ВариантыОтчетов.Ссылка В (&ОтключенныеВариантыПрограммы)
	|			ТОГДА 4
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Причина
	|ПОМЕСТИТЬ втВарианты
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|ГДЕ
	|	ВариантыОтчетов.Ссылка В(&МассивВариантов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втВарианты.Ссылка КАК Ссылка,
	|	ПредопределенныеВариантыОтчетовРазмещение.Подсистема КАК Подсистема,
	|	ПредопределенныеВариантыОтчетовРазмещение.Важный КАК Важный,
	|	ПредопределенныеВариантыОтчетовРазмещение.СмТакже КАК СмТакже
	|ПОМЕСТИТЬ втОбщие
	|ИЗ
	|	втВарианты КАК втВарианты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетов.Размещение КАК ПредопределенныеВариантыОтчетовРазмещение
	|		ПО (втВарианты.Причина = 0)
	|			И втВарианты.ПредопределенныйВариант = ПредопределенныеВариантыОтчетовРазмещение.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВариантыОтчетовРазмещение.Ссылка КАК Ссылка,
	|	ВариантыОтчетовРазмещение.Использование КАК Использование,
	|	ВариантыОтчетовРазмещение.Подсистема КАК Подсистема,
	|	ВариантыОтчетовРазмещение.Важный КАК Важный,
	|	ВариантыОтчетовРазмещение.СмТакже КАК СмТакже
	|ПОМЕСТИТЬ втРазделенные
	|ИЗ
	|	втВарианты КАК втВарианты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВариантыОтчетов.Размещение КАК ВариантыОтчетовРазмещение
	|		ПО (втВарианты.Причина = 0)
	|			И втВарианты.Ссылка = ВариантыОтчетовРазмещение.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	втВарианты.Ссылка,
	|	втВарианты.Причина КАК Причина
	|ИЗ
	|	втВарианты КАК втВарианты
	|ГДЕ
	|	втВарианты.Причина <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Причина
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(НастройкиРазделенных.Подсистема, НастройкиОбщих.Подсистема) КАК Ссылка,
	|	СУММА(1) КАК Количество,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(НастройкиРазделенных.Важный, НастройкиОбщих.Важный) = ИСТИНА
	|			ТОГДА &ПредставлениеВажный
	|		КОГДА ЕСТЬNULL(НастройкиРазделенных.СмТакже, НастройкиОбщих.СмТакже) = ИСТИНА
	|			ТОГДА &ПредставлениеСмТакже
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Важность
	|ИЗ
	|	втОбщие КАК НастройкиОбщих
	|		ПОЛНОЕ СОЕДИНЕНИЕ втРазделенные КАК НастройкиРазделенных
	|		ПО НастройкиОбщих.Ссылка = НастройкиРазделенных.Ссылка
	|			И НастройкиОбщих.Подсистема = НастройкиРазделенных.Подсистема
	|ГДЕ
	|	(НастройкиРазделенных.Использование = ИСТИНА
	|			ИЛИ НастройкиРазделенных.Использование ЕСТЬ NULL )
	|
	|СГРУППИРОВАТЬ ПО
	|	ЕСТЬNULL(НастройкиРазделенных.Подсистема, НастройкиОбщих.Подсистема),
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(НастройкиРазделенных.Важный, НастройкиОбщих.Важный) = ИСТИНА
	|			ТОГДА &ПредставлениеВажный
	|		КОГДА ЕСТЬNULL(НастройкиРазделенных.СмТакже, НастройкиОбщих.СмТакже) = ИСТИНА
	|			ТОГДА &ПредставлениеСмТакже
	|		ИНАЧЕ """"
	|	КОНЕЦ";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПолныеПраваНаВарианты",        ВариантыОтчетов.ПолныеПраваНаВарианты());
	Запрос.УстановитьПараметр("ТекущийПользователь",          Пользователи.ТекущийПользователь());
	Запрос.УстановитьПараметр("МассивВариантов",              ИзменяемыеВарианты.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("ОтчетыПользователя",           ВариантыОтчетов.ОтчетыТекущегоПользователя());
	Запрос.УстановитьПараметр("ОтключенныеВариантыПрограммы", ВариантыОтчетовПовтИсп.ОтключенныеВариантыПрограммы());
	Запрос.УстановитьПараметр("ПредставлениеВажный",          ВариантыОтчетовКлиентСервер.ПредставлениеВажный());
	Запрос.УстановитьПараметр("ПредставлениеСмТакже",         ВариантыОтчетовКлиентСервер.ПредставлениеСмТакже());
	
	Запрос.Текст = ТекстЗапроса;
	ВременныеТаблицы = Запрос.ВыполнитьПакет();
	
	ОтфильтрованныеВарианты = ВременныеТаблицы[3].Выгрузить();
	КоличествоОшибок = ОтфильтрованныеВарианты.Количество();
	
	Если КоличествоОшибок > 0 Тогда
		РезультатВыполнения = Новый Структура;
		ТекстОшибок = НСтр("ru = 'Варианты отчетов, исключенные из списка выбранных:'");
		ТекущаяПричина = 0;
		ПрефиксЗаписи = Символы.ПС + "    ";
		Для Каждого СтрокаТаблицы Из ОтфильтрованныеВарианты Цикл
			Если ТекущаяПричина <> СтрокаТаблицы.Причина Тогда
				ТекущаяПричина = СтрокаТаблицы.Причина;
				ТекстОшибок = ТекстОшибок + Символы.ПС + Символы.ПС + "  ";
				Если ТекущаяПричина = 1 Тогда
					ТекстОшибок = ТекстОшибок + НСтр("ru = 'Помеченные на удаление:'");
				ИначеЕсли ТекущаяПричина = 2 Тогда
					ТекстОшибок = ТекстОшибок + НСтр("ru = 'Недостаточно прав для изменения:'");
				ИначеЕсли ТекущаяПричина = 3 Тогда
					ТекстОшибок = ТекстОшибок + НСтр("ru = 'Отчет отключен или недоступен по правам:'");
				ИначеЕсли ТекущаяПричина = 4 Тогда
					ТекстОшибок = ТекстОшибок + НСтр("ru = 'Вариант отчета отключен по функциональной опции:'");
				КонецЕсли;
			КонецЕсли;
			
			ТекстОшибок = ТекстОшибок + Символы.ПС + "    - " + Строка(СтрокаТаблицы.Ссылка);
			ИзменяемыеВарианты.Удалить(ИзменяемыеВарианты.НайтиПоЗначению(СтрокаТаблицы.Ссылка));
		КонецЦикла;
		
		КоличествоВариантов = ИзменяемыеВарианты.Количество();
		
		РезультатВыполнения = СтандартныеПодсистемыКлиентСервер.НовыйРезультатВыполнения();
		
		Если КоличествоВариантов = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Нет прав для размещения в разделах выбранных вариантов отчетов.'");
			Элементы.ДеревоПодсистем.Доступность = Ложь;
			РезультатВыполнения.Вставить("Отказ", Истина);
		Иначе
			ТекстСообщения = НСтр("ru = 'Нет прав для размещения в разделах некоторых вариантов отчетов (%1).'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", Формат(КоличествоОшибок, "ЧГ="));
			Элементы.ДеревоПодсистем.Доступность = Истина;
		КонецЕсли;
		
		ВыводПредупреждения = РезультатВыполнения.ВыводПредупреждения;
		ВыводПредупреждения.Использование = Истина;
		ВыводПредупреждения.Текст = ТекстСообщения;
		ВыводПредупреждения.ТекстОшибок = ТекстОшибок;
		
		РезультатВыполнения = Новый ФиксированнаяСтруктура(РезультатВыполнения);
	Иначе
		Элементы.ДеревоПодсистем.Доступность = Истина;
	КонецЕсли;
	
	ВхожденияПодсистем = ВременныеТаблицы[4].Выгрузить();
	
	ДеревоИсточник = ВариантыОтчетовПовтИсп.ПодсистемыТекущегоПользователя();
	
	ДеревоПриемник = РеквизитФормыВЗначение("ДеревоПодсистем", Тип("ДеревоЗначений"));
	ДеревоПриемник.Строки.Очистить();
	
	ДобавитьПодсистемыВДерево(ДеревоПриемник, ДеревоИсточник, ВхожденияПодсистем);
	
	ЗначениеВРеквизитФормы(ДеревоПриемник, "ДеревоПодсистем");
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	Кэш = Новый Структура;
	
	НачатьТранзакцию();
	Для Каждого ЭлементСписка Из ИзменяемыеВарианты Цикл
		ВариантОбъект = ЭлементСписка.Значение.ПолучитьОбъект();
		ВариантыОтчетов.ДеревоПодсистемЗаписать(ЭтотОбъект, ВариантОбъект, Кэш);
		ВариантОбъект.Записать();
	КонецЦикла;
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура ДобавитьПодсистемыВДерево(ПриемникРодитель, ИсточникРодитель, ВхожденияПодсистем)
	Для Каждого Источник Из ИсточникРодитель.Строки Цикл
		
		Приемник = ПриемникРодитель.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(Приемник, Источник);
		
		ВхожденияЭтойПодсистемы = ВхожденияПодсистем.Скопировать(Новый Структура("Ссылка", Приемник.Ссылка));
		Если ВхожденияЭтойПодсистемы.Количество() = 1 Тогда
			Приемник.Важность = ВхожденияЭтойПодсистемы[0].Важность;
		ИначеЕсли ВхожденияЭтойПодсистемы.Количество() = 0 Тогда
			Приемник.Важность = "";
		Иначе
			Приемник.Важность = СмешаннаяВажность; // Так же используется для условного оформления.
		КонецЕсли;
		
		ВхожденияВариантов = ВхожденияЭтойПодсистемы.Итог("Количество");
		Если ВхожденияВариантов = КоличествоВариантов Тогда
			Приемник.Использование = 1;
		ИначеЕсли ВхожденияВариантов = 0 Тогда
			Приемник.Использование = 0;
		Иначе
			Приемник.Использование = 2;
		КонецЕсли;
		
		//Приемник.Важность      = Приемник.ВажностьПоУмолчанию;
		//Приемник.Использование = Приемник.ИспользованиеПоУмолчанию;
		
		// Рекурсия
		ДобавитьПодсистемыВДерево(Приемник, Источник, ВхожденияПодсистем);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
