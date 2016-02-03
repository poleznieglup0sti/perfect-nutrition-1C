﻿////////////////////////////////////////////////////////////////////////////////
//                          ИСПОЛЬЗОВАНИЕ ФОРМЫ                               //
//
// Дополнительные параметры открытия формы подбора:
//
// РасширенныйПодбор - Булево - если Истина - открывается расширенная форма
//  подбора пользователей. Используется вместе с параметром
//  ПараметрыРасширеннойФормыПодбора.
// ПараметрыРасширеннойФормыПодбора - Строка - ссылка на структуру,
//  содержащую параметры расширенной формы подбора во
//  временном хранилище.
//  Параметры структуры:
//    ЗаголовокФормыПодбора - Строка - заголовок формы подбора.
//    ВыбранныеПользователи - Массив - массив уже выбранных пользователей.
//

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Начальное значение настройки до загрузки данных из настроек.
	ВыбиратьИерархически = Истина;
	
	ЗаполнитьХранимыеПараметры();
	ЗаполнитьПараметрыДинамическихСписков();
	
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = "ВыборПодбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	// Скрытие пользователей с пустым идентификатором, если значение параметра Истина.
	Если Параметры.СкрытьПользователейБезПользователяИБ Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ВнешниеПользователиСписок,
			"ИдентификаторПользователяИБ",
			Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"),
			ВидСравненияКомпоновкиДанных.НеРавно);
	КонецЕсли;
	
	// Скрытие переданного пользователя из формы выбора пользователей.
	Если ТипЗнч(Параметры.СкрываемыеПользователи) = Тип("СписокЗначений") Тогда
		
		ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеВСписке;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ВнешниеПользователиСписок,
			"Ссылка",
			Параметры.СкрываемыеПользователи,
			ВидСравненияКД);
	КонецЕсли;
	
	НастроитьПорядокГруппыВсеВнешниеПользователи(ГруппыВнешнихПользователей);
	ОформитьИСкрытьНедействительныхВнешнихПользователей();
	
	ХранимыеПараметры.Вставить("РасширенныйПодбор", Параметры.РасширенныйПодбор);
	Элементы.ВыбранныеПользователиИГруппы.Видимость = ХранимыеПараметры.РасширенныйПодбор;
	ХранимыеПараметры.Вставить(
		"ИспользоватьГруппы", ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей"));
	
	Если НЕ ПравоДоступа("Добавление", Метаданные.Справочники.ВнешниеПользователи) Тогда
		Элементы.СоздатьВнешнегоПользователя.Видимость = Ложь;
	КонецЕсли;
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы().Локальный) Тогда
		Если Элементы.Найти("ПользователиИБ") <> Неопределено Тогда
			Элементы.ПользователиИБ.Видимость = Ложь;
		КонецЕсли;
		Элементы.СведенияОВнешнихПользователях.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		
		Если Элементы.Найти("ПользователиИБ") <> Неопределено Тогда
			Элементы.ПользователиИБ.Видимость = Ложь;
		КонецЕсли;
		Элементы.СведенияОВнешнихПользователях.Видимость = Ложь;
		
		// Отбор не помеченных на удаление.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ВнешниеПользователиСписок, "ПометкаУдаления", Ложь, , , Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
		
		Элементы.ВнешниеПользователиСписок.РежимВыбора = Истина;
		Элементы.ГруппыВнешнихПользователей.РежимВыбора =
			ХранимыеПараметры.ВыборГруппВнешнихПользователей;
		
		// Отключение перетаскивания пользователя в формах выбора и подбора пользователей.
		Элементы.ВнешниеПользователиСписок.РазрешитьНачалоПеретаскивания = Ложь;
		
		Если Параметры.Свойство("ИдентификаторыНесуществующихПользователейИБ") Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				ВнешниеПользователиСписок, "ИдентификаторПользователяИБ",
				Параметры.ИдентификаторыНесуществующихПользователейИБ,
				ВидСравненияКомпоновкиДанных.ВСписке, , Истина,
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		КонецЕсли;
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Элементы.ВнешниеПользователиСписок.МножественныйВыбор = Истина;
			
			Если ХранимыеПараметры.РасширенныйПодбор Тогда
				ЭтотОбъект.КлючСохраненияПоложенияОкна = "РасширенныйПодборВнешнихПользователей";
				ИзменитьПараметрыРасширеннойФормыПодбора();
			Иначе
				ЭтотОбъект.КлючСохраненияПоложенияОкна = "РежимПодбораВнешнихПользователей";
			КонецЕсли;
			
			Если ХранимыеПараметры.ВыборГруппВнешнихПользователей Тогда
				Элементы.ГруппыВнешнихПользователей.МножественныйВыбор = Истина;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Элементы.Комментарии.Видимость = Ложь;
		Элементы.ВыбратьВнешнегоПользователя.Видимость = Ложь;
		Элементы.ВыбратьГруппуВнешнихПользователей.Видимость = Ложь;
	КонецЕсли;
	
	ХранимыеПараметры.Вставить("ГруппаВсеПользователи", Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи);
	ХранимыеПараметры.Вставить("ТекущаяСтрока", Параметры.ТекущаяСтрока);
	НастроитьФормуПоИспользованиюГруппПользователей();
	ХранимыеПараметры.Удалить("ТекущаяСтрока");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.РежимВыбора Тогда
		ПроверкаИзмененияТекущегоЭлементаФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_ГруппыВнешнихПользователей")
	   И Источник = Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока Тогда
		
		Элементы.ГруппыВнешнихПользователей.Обновить();
		Элементы.ВнешниеПользователиСписок.Обновить();
		ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
		
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("Запись_НаборКонстант") Тогда
		
		Если ВРег(Источник) = ВРег("ИспользоватьГруппыПользователей") Тогда
			ПодключитьОбработчикОжидания("ПриИзмененииИспользованияГруппПользователей", 0.1, Истина);
		КонецЕсли;
		
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("РазмещениеПользователейВГруппах") Тогда
		
		Элементы.ВнешниеПользователиСписок.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ТипЗнч(Настройки["ВыбиратьИерархически"]) = Тип("Булево") Тогда
		ВыбиратьИерархически = Настройки["ВыбиратьИерархически"];
	КонецЕсли;
	
	Если НЕ ВыбиратьИерархически Тогда
		ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбиратьИерархическиПриИзменении(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительныхПользователейПриИзменении(Элемент)
	ПереключитьОтображениеНедействительныхПользователей(ПоказыватьНедействительныхПользователей);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГруппыВнешнихПользователей

&НаКлиенте
Процедура ГруппыВнешнихПользователейПриАктивизацииСтроки(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ХранимыеПараметры.РасширенныйПодбор Тогда
		ОповеститьОВыборе(Значение);
	Иначе
		
		ПолучитьКартинкиИЗаполнитьСписокВыбранных(Значение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ Копирование Тогда
		Отказ = Истина;
		ПараметрыФормы = Новый Структура;
		
		Если ЗначениеЗаполнено(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока) Тогда
			
			ПараметрыФормы.Вставить(
				"ЗначенияЗаполнения",
				Новый Структура("Родитель", Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока));
		КонецЕсли;
		
		ОткрытьФорму(
			"Справочник.ГруппыВнешнихПользователей.ФормаОбъекта",
			ПараметрыФормы,
			Элементы.ГруппыВнешнихПользователей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбиратьИерархически Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Для перетаскивания пользователя в группы необходимо отключить
			|флажок ""Показывать пользователей дочерних групп"".'"));
		Возврат;
	КонецЕсли;
	
	Если Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока = Строка
		Или Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение Тогда
		Перемещение = Истина;
	Иначе
		Перемещение = Ложь;
	КонецЕсли;
	
	ТекущаяСтрокаГруппы = Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока;
	ГруппаСТипомВсеОбъектыАвторизации = 
		Элементы.ГруппыВнешнихПользователей.ДанныеСтроки(ТекущаяСтрокаГруппы).ВсеОбъектыАвторизации;
	
	Если Строка = ХранимыеПараметры.ГруппаВсеПользователи
		И ГруппаСТипомВсеОбъектыАвторизации Тогда
		СообщениеПользователю = Новый Структура("Сообщение, ЕстьОшибки, Пользователи",
			НСтр("ru = 'Из групп с типом участников ""Все пользователи заданного типа"" исключение пользователей невозможно.'"),
			Истина,
			Неопределено);
	Иначе
		ГруппаПомеченаНаУдаление = Элементы.ГруппыВнешнихПользователей.ДанныеСтроки(Строка).ПометкаУдаления;
		
		КоличествоПользователей = ПараметрыПеретаскивания.Значение.Количество();
		
		ДействиеИсключитьПользователя = (ХранимыеПараметры.ГруппаВсеПользователи = Строка);
		
		ДействиеСПользователем = 
			?((ХранимыеПараметры.ГруппаВсеПользователи = ТекущаяСтрокаГруппы) ИЛИ ГруппаСТипомВсеОбъектыАвторизации,
			НСтр("ru = 'Включить'"),
			?(Перемещение, НСтр("ru = 'Переместить'"), НСтр("ru = 'Скопировать'")));
		
		Если ГруппаПомеченаНаУдаление Тогда
			ШаблонДействия = ?(Перемещение, НСтр("ru = 'Группа ""%1"" помечена на удаление. %2'"), 
				НСтр("ru = 'Группа ""%1"" помечена на удаление. %2'"));
			ДействиеСПользователем = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонДействия, Строка(Строка), ДействиеСПользователем);
		КонецЕсли;
		
		Если КоличествоПользователей = 1 Тогда
			
			Если ДействиеИсключитьПользователя Тогда
				ШаблонВопроса = НСтр("ru = 'Исключить пользователя ""%2"" из группы ""%4""?'");
			ИначеЕсли Не ГруппаПомеченаНаУдаление Тогда
				ШаблонВопроса = НСтр("ru = '%1 пользователя ""%2"" в группу ""%3""?'");
			Иначе
				ШаблонВопроса = НСтр("ru = '%1 пользователя ""%2"" в эту группу?'");
			КонецЕсли;
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонВопроса, ДействиеСПользователем, Строка(ПараметрыПеретаскивания.Значение[0]),
				Строка(Строка), Строка(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока));
			
		Иначе
			
			Если ДействиеИсключитьПользователя Тогда
				ШаблонВопроса = НСтр("ru = 'Исключить пользователей (%2) из группы ""%4""?'");
			ИначеЕсли Не ГруппаПомеченаНаУдаление Тогда
				ШаблонВопроса = НСтр("ru = '%1 пользователей (%2) в группу ""%3""?'");
			Иначе
				ШаблонВопроса = НСтр("ru = '%1 пользователей (%2) в эту группу?'");
			КонецЕсли;
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонВопроса, ДействиеСПользователем, КоличествоПользователей,
				Строка(Строка), Строка(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока));
			
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура("ПараметрыПеретаскивания, Строка, Перемещение",
			ПараметрыПеретаскивания.Значение, Строка, Перемещение);
		Оповещение = Новый ОписаниеОповещения("ГруппыВнешнихПользователейПеретаскиваниеОбработкаВопроса", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
		Возврат;
		
	КонецЕсли;
	
	ГруппыВнешнихПользователейПеретаскиваниеЗавершение(СообщениеПользователю);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВнешниеПользователи

&НаКлиенте
Процедура ВнешниеПользователиСписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ХранимыеПараметры.РасширенныйПодбор Тогда
		ОповеститьОВыборе(Значение);
	Иначе
		ПолучитьКартинкиИЗаполнитьСписокВыбранных(Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешниеПользователиСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура(
		"ГруппаНовогоВнешнегоПользователя", Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока);
	
	Если ЗначениеЗаполнено(ХранимыеПараметры.ОтборОбъектАвторизации) Тогда
		
		ПараметрыФормы.Вставить(
			"ОбъектАвторизацииНовогоВнешнегоПользователя",
			ХранимыеПараметры.ОтборОбъектАвторизации);
	КонецЕсли;
	
	Если Копирование И Элемент.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элемент.ТекущаяСтрока);
	КонецЕсли;
	
	ОткрытьФорму(
		"Справочник.ВнешниеПользователи.ФормаОбъекта",
		ПараметрыФормы,
		Элементы.ВнешниеПользователиСписок);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешниеПользователиСписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокВыбранныхПользователейИГрупп

&НаКлиенте
Процедура СписокВыбранныхПользователейИГруппВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	УдалитьИзСпискаВыбранных();
	ЭтотОбъект.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбранныхПользователейИГруппПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьГруппуВнешнихПользователей(Команда)
	
	Элементы.ГруппыВнешнихПользователей.ДобавитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура НазначитьГруппы(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Пользователи", Элементы.ВнешниеПользователиСписок.ВыделенныеСтроки);
	ПараметрыФормы.Вставить("ВнешниеПользователи", Истина);
	
	ОткрытьФорму("ОбщаяФорма.ГруппыПользователей", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьИЗакрыть(Команда)
	
	Если ХранимыеПараметры.РасширенныйПодбор Тогда
		МассивПользователей = РезультатВыбора();
		ОповеститьОВыборе(МассивПользователей);
		ЭтотОбъект.Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПользователяКоманда(Команда)
	
	МассивПользователей = Элементы.ВнешниеПользователиСписок.ВыделенныеСтроки;
	ПолучитьКартинкиИЗаполнитьСписокВыбранных(МассивПользователей);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыборПользователяИлиГруппы(Команда)
	
		УдалитьИзСпискаВыбранных();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСписокВыбранныхПользователейИГрупп(Команда)
	
	УдалитьИзСпискаВыбранных(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьГруппу(Команда)
	
	МассивГрупп = Элементы.ГруппыВнешнихПользователей.ВыделенныеСтроки;
	ПолучитьКартинкиИЗаполнитьСписокВыбранных(МассивГрупп);
	
КонецПроцедуры

&НаКлиенте
Процедура СведенияОВнешнихПользователях(Команда)
	
	ОткрытьФорму(
		"Отчет.СведенияОПользователях.ФормаОбъекта",
		Новый Структура("КлючВарианта", "СведенияОВнешнихПользователях"),
		ЭтотОбъект,
		"СведенияОВнешнихПользователях");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьХранимыеПараметры()
	
	ХранимыеПараметры = Новый Структура;
	ХранимыеПараметры.Вставить("ВыборГруппВнешнихПользователей", Параметры.ВыборГруппВнешнихПользователей);
	
	Если Параметры.Отбор.Свойство("ОбъектАвторизации") Тогда
		ХранимыеПараметры.Вставить("ОтборОбъектАвторизации", Параметры.Отбор.ОбъектАвторизации);
	Иначе
		ХранимыеПараметры.Вставить("ОтборОбъектАвторизации", Неопределено);
	КонецЕсли;
	
	// Подготовка представлений типов объектов авторизации.
	ХранимыеПараметры.Вставить("ПредставлениеТиповОбъектовАвторизации", Новый СписокЗначений);
	ТипыОбъектовАвторизации = Метаданные.Справочники.ВнешниеПользователи.Реквизиты.ОбъектАвторизации.Тип.Типы();
	
	Для каждого ТекущийТипОбъектовАвторизации Из ТипыОбъектовАвторизации Цикл
		Если Не ОбщегоНазначения.ЭтоСсылка(ТекущийТипОбъектовАвторизации) Тогда
			Продолжить;
		КонецЕсли;
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТекущийТипОбъектовАвторизации);
		ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);
		
		ХранимыеПараметры.ПредставлениеТиповОбъектовАвторизации.Добавить(
			ОписаниеТипа.ПривестиЗначение(Неопределено),
			Метаданные.НайтиПоТипу(ТекущийТипОбъектовАвторизации).Синоним);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыДинамическихСписков()
	
	ТипОбъектовАвторизации = Неопределено;
	Параметры.Свойство("ТипОбъектовАвторизации", ТипОбъектовАвторизации);
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(
		ГруппыВнешнихПользователей,
		"ЛюбойТипОбъектовАвторизации",
		ТипОбъектовАвторизации = Неопределено);
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(
		ГруппыВнешнихПользователей,
		"ТипОбъектовАвторизации",
		ТипЗнч(ТипОбъектовАвторизации));
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(
		ВнешниеПользователиСписок,
		"ЛюбойТипОбъектовАвторизации",
		ТипОбъектовАвторизации = Неопределено);
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(
		ВнешниеПользователиСписок,
		"ТипОбъектовАвторизации",
		ТипЗнч(ТипОбъектовАвторизации));
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПорядокГруппыВсеВнешниеПользователи(Список)
	
	Перем Порядок;
	
	// Порядок.
	Порядок = Список.КомпоновщикНастроек.Настройки.Порядок;
	Порядок.ИдентификаторПользовательскойНастройки = "ОсновнойПорядок";
	
	Порядок.Элементы.Очистить();
	
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Предопределенный");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование = Истина;
	
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Наименование");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОформитьИСкрытьНедействительныхВнешнихПользователей()
	
	// Оформление.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.НедоступныеДанныеЦвет.Значение;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВнешниеПользователиСписок.Недействителен");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("ВнешниеПользователиСписок");
	ЭлементОформляемогоПоля.Использование = Истина;
	
	// Скрытие.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ВнешниеПользователиСписок, "Недействителен", Ложь, , , Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаИзмененияТекущегоЭлементаФормы()
	
	Если ТекущийЭлемент.Имя <> ИмяТекущегоЭлемента Тогда
		ПриИзмененииТекущегоЭлементаФормы();
		ИмяТекущегоЭлемента = ТекущийЭлемент.Имя;
	КонецЕсли;
	
#Если ВебКлиент Тогда
	ПодключитьОбработчикОжидания("ПроверкаИзмененияТекущегоЭлементаФормы", 0.7, Истина);
#Иначе
	ПодключитьОбработчикОжидания("ПроверкаИзмененияТекущегоЭлементаФормы", 0.1, Истина);
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииТекущегоЭлементаФормы()
	
	Если ТекущийЭлемент.Имя = "ГруппыВнешнихПользователей" Тогда
		Элементы.Комментарии.ТекущаяСтраница = Элементы.КомментарийГруппы;
		
	ИначеЕсли ТекущийЭлемент.Имя = "ВнешниеПользователиСписок" Тогда
		Элементы.Комментарии.ТекущаяСтраница = Элементы.КомментарийПользователя;
		
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура УдалитьИзСпискаВыбранных(УдалитьВсех = Ложь)
	
	Если УдалитьВсех Тогда
		ВыбранныеПользователиИГруппы.Очистить();
		ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
		Возврат;
	КонецЕсли;
	
	МассивЭлементовСписка = Элементы.СписокВыбранныхПользователейИГрупп.ВыделенныеСтроки;
	Для Каждого ЭлементСписка Из МассивЭлементовСписка Цикл
		ВыбранныеПользователиИГруппы.Удалить(ВыбранныеПользователиИГруппы.НайтиПоИдентификатору(ЭлементСписка));
	КонецЦикла;
	
	ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКартинкиИЗаполнитьСписокВыбранных(МассивВыбранныхЭлементов)
	
	ВыбранныеЭлементыИКартинки = Новый Массив;
	Для Каждого ВыбранныйЭлемент Из МассивВыбранныхЭлементов Цикл
		
		Если ТипЗнч(ВыбранныйЭлемент) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
			НомерКартинки = Элементы.ВнешниеПользователиСписок.ДанныеСтроки(ВыбранныйЭлемент).НомерКартинки;
		Иначе
			НомерКартинки = Элементы.ГруппыВнешнихПользователей.ДанныеСтроки(ВыбранныйЭлемент).НомерКартинки;
		КонецЕсли;
		
		ВыбранныеЭлементыИКартинки.Добавить(
			Новый Структура("ВыбранныйЭлемент, НомерКартинки", ВыбранныйЭлемент, НомерКартинки));
	КонецЦикла;
	
	ЗаполнитьСписокВыбранныхПользователейИГрупп(ВыбранныеЭлементыИКартинки);
	
КонецПроцедуры

&НаСервере
Функция РезультатВыбора()
	
	ВыбранныеПользователиТаблицаЗначений = ВыбранныеПользователиИГруппы.Выгрузить( , "Пользователь");
	МассивПользователей = ВыбранныеПользователиТаблицаЗначений.ВыгрузитьКолонку("Пользователь");
	Возврат МассивПользователей;
	
КонецФункции

&НаСервере
Процедура ИзменитьПараметрыРасширеннойФормыПодбора()
	
	// Загрузка списка выбранных пользователей
	ПараметрыРасширеннойФормыПодбора = ПолучитьИзВременногоХранилища(Параметры.ПараметрыРасширеннойФормыПодбора);
	ВыбранныеПользователиИГруппы.Загрузить(ПараметрыРасширеннойФормыПодбора.ВыбранныеПользователи);
	ХранимыеПараметры.Вставить("ЗаголовокФормыПодбора", ПараметрыРасширеннойФормыПодбора.ЗаголовокФормыПодбора);
	Пользователи.ЗаполнитьНомераКартинокПользователей(ВыбранныеПользователиИГруппы, "Пользователь", "НомерКартинки");
	// Установка параметров расширенной формы подбора.
	Элементы.ЗавершитьИЗакрыть.Видимость                      = Истина;
	Элементы.ГруппаВыбратьПользователя.Видимость              = Истина;
	// Включение видимости списка выбранных пользователей.
	Элементы.ВыбранныеПользователиИГруппы.Видимость           = Истина;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей") Тогда
		Элементы.ГруппыИПользователи.Группировка                 = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		Элементы.ГруппыИПользователи.ШиринаПодчиненныхЭлементов  = ШиринаПодчиненныхЭлементовФормы.Одинаковая;
		Элементы.ВнешниеПользователиСписок.Высота                = 5;
		Элементы.ГруппыВнешнихПользователей.Высота               = 3;
		ЭтотОбъект.Высота                                        = 17;
		Элементы.ГруппаВыбратьГруппу.Видимость                   = Истина;
		// Включение отображения заголовков списков ПользователиСписок и ГруппыПользователей.
		Элементы.ГруппыВнешнихПользователей.ПоложениеЗаголовка   = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.ВнешниеПользователиСписок.ПоложениеЗаголовка    = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.ВнешниеПользователиСписок.Заголовок             = НСтр("ru = 'Пользователи в группе'");
		Если ПараметрыРасширеннойФормыПодбора.Свойство("ПодборГруппНевозможен") Тогда
			Элементы.ВыбратьГруппу.Видимость                     = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ОтменитьВыборПользователя.Видимость             = Истина;
		Элементы.ОчиститьСписокВыбранных.Видимость               = Истина;
	КонецЕсли;
	
	// Добавление количества выбранных пользователей в заголовке выбранных пользователей и групп.
	ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп()
	
	Если ХранимыеПараметры.ИспользоватьГруппы Тогда
		ЗаголовокВыбранныеПользователиИГруппы = НСтр("ru = 'Выбранные пользователи и группы (%1)'");
	Иначе
		ЗаголовокВыбранныеПользователиИГруппы = НСтр("ru = 'Выбранные пользователи (%1)'");
	КонецЕсли;
	
	КоличествоПользователей = ВыбранныеПользователиИГруппы.Количество();
	Если КоличествоПользователей <> 0 Тогда
		Элементы.СписокВыбранныхПользователейИГрупп.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ЗаголовокВыбранныеПользователиИГруппы, КоличествоПользователей);
	Иначе
		
		Если ХранимыеПараметры.ИспользоватьГруппы Тогда
			Элементы.СписокВыбранныхПользователейИГрупп.Заголовок = НСтр("ru = 'Выбранные пользователи и группы'");
		Иначе
			Элементы.СписокВыбранныхПользователейИГрупп.Заголовок = НСтр("ru = 'Выбранные пользователи'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбранныхПользователейИГрупп(ВыбранныеЭлементыИКартинки)
	
	Для Каждого СтрокаМассива Из ВыбранныеЭлементыИКартинки Цикл
		
		ВыбранныйПользовательИлиГруппа = СтрокаМассива.ВыбранныйЭлемент;
		НомерКартинки = СтрокаМассива.НомерКартинки;
		
		ПараметрыОтбора = Новый Структура("Пользователь", ВыбранныйПользовательИлиГруппа);
		Найденный = ВыбранныеПользователиИГруппы.НайтиСтроки(ПараметрыОтбора);
		Если Найденный.Количество() = 0 Тогда
			
			СтрокаВыбранныеПользователи = ВыбранныеПользователиИГруппы.Добавить();
			СтрокаВыбранныеПользователи.Пользователь = ВыбранныйПользовательИлиГруппа;
			СтрокаВыбранныеПользователи.НомерКартинки = НомерКартинки;
			ЭтотОбъект.Модифицированность = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ВыбранныеПользователиИГруппы.Сортировать("Пользователь Возр");
	ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииИспользованияГруппПользователей()
	
	НастроитьФормуПоИспользованиюГруппПользователей();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоИспользованиюГруппПользователей()
	
	Если ХранимыеПараметры.Свойство("ТекущаяСтрока") Тогда
		
		Если ТипЗнч(Параметры.ТекущаяСтрока) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда
			
			Если ХранимыеПараметры.ИспользоватьГруппы Тогда
				Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока = ХранимыеПараметры.ТекущаяСтрока;
			Иначе
				Параметры.ТекущаяСтрока = Неопределено;
			КонецЕсли;
		Иначе
			ТекущийЭлемент = Элементы.ВнешниеПользователиСписок;
			
			Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока =
				Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи;
		КонецЕсли;
	Иначе
		Если НЕ ХранимыеПараметры.ИспользоватьГруппы
		   И Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока
		     <> Справочники.ГруппыПользователей.ВсеПользователи Тогда
			
			Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока =
				Справочники.ГруппыПользователей.ВсеПользователи;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ГруппаПоказыватьВнешнихПользователейДочернихГрупп.Видимость =
		ХранимыеПараметры.ИспользоватьГруппы;
	
	Если ХранимыеПараметры.РасширенныйПодбор Тогда
		Элементы.НазначитьГруппы.Видимость = Ложь;
	Иначе
		Элементы.НазначитьГруппы.Видимость = ХранимыеПараметры.ИспользоватьГруппы;
	КонецЕсли;
	
	Элементы.СоздатьГруппуВнешнихПользователей.Видимость =
		ПравоДоступа("Добавление", Метаданные.Справочники.ГруппыВнешнихПользователей)
		И ХранимыеПараметры.ИспользоватьГруппы;
	
	ВыборГруппВнешнихПользователей = ХранимыеПараметры.ВыборГруппВнешнихПользователей
	                               И ХранимыеПараметры.ИспользоватьГруппы
	                               И Параметры.РежимВыбора;
	
	Если Параметры.РежимВыбора Тогда
		
		Элементы.ВыбратьГруппуВнешнихПользователей.Видимость   = 
			?(ХранимыеПараметры.РасширенныйПодбор, Ложь, ВыборГруппВнешнихПользователей);
		Элементы.ВыбратьВнешнегоПользователя.КнопкаПоУмолчанию =
			?(ХранимыеПараметры.РасширенныйПодбор, Ложь, Не ВыборГруппВнешнихПользователей);
		Элементы.ВыбратьВнешнегоПользователя.Видимость         = Не ХранимыеПараметры.РасширенныйПодбор;
		
		АвтоЗаголовок = Ложь;
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			
			Если ВыборГруппВнешнихПользователей Тогда
				
				Если ХранимыеПараметры.РасширенныйПодбор Тогда
					Заголовок = ХранимыеПараметры.ЗаголовокФормыПодбора;
				Иначе
					Заголовок = НСтр("ru = 'Подбор внешних пользователей и групп'");
				КонецЕсли;
				
				Элементы.ВыбратьВнешнегоПользователя.Заголовок =
					НСтр("ru = 'Выбрать внешних пользователей'");
				
				Элементы.ВыбратьГруппуВнешнихПользователей.Заголовок =
					НСтр("ru = 'Выбрать группы'");
				
			Иначе
				Если ХранимыеПараметры.РасширенныйПодбор Тогда
					Заголовок = ХранимыеПараметры.ЗаголовокФормыПодбора;
				Иначе
					Заголовок = НСтр("ru = 'Подбор внешних пользователей'");
				КонецЕсли;
			КонецЕсли;
		Иначе
			// Режим выбора.
			Если ВыборГруппВнешнихПользователей Тогда
				Заголовок = НСтр("ru = 'Выбор внешнего пользователя или группы'");
				
				Элементы.ВыбратьВнешнегоПользователя.Заголовок = НСтр("ru = 'Выбрать внешнего пользователя'");
			Иначе
				Заголовок = НСтр("ru = 'Выбор внешнего пользователя'");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция ПеремещениеПользователяВНовуюГруппу(МассивПользователей, НоваяГруппаВладелец, Перемещение)
	
	Если НоваяГруппаВладелец = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТекущаяГруппаВладелец = Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока;
	СообщениеПользователю = ПользователиСлужебный.ПеремещениеПользователяВНовуюГруппу(
		МассивПользователей, ТекущаяГруппаВладелец, НоваяГруппаВладелец, Перемещение);
	
	Элементы.ВнешниеПользователиСписок.Обновить();
	Элементы.ГруппыВнешнихПользователей.Обновить();
	
	Возврат СообщениеПользователю;
	
КонецФункции

&НаКлиенте
Процедура ПереключитьОтображениеНедействительныхПользователей(ПоказатьНедействительных)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ВнешниеПользователиСписок, "Недействителен", Ложь, , ,
		НЕ ПоказатьНедействительных);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСодержимоеФормыПриИзмененииГруппы(Форма)
	
	Элементы = Форма.Элементы;
	
	Если НЕ Форма.ХранимыеПараметры.ИспользоватьГруппы
	 ИЛИ Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока = ПредопределенноеЗначение(
	         "Справочник.ГруппыВнешнихПользователей.ВсеВнешниеПользователи") Тогда
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(
			Форма.ВнешниеПользователиСписок, "ВыбиратьИерархически", Истина);
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(
			Форма.ВнешниеПользователиСписок,
			"ГруппаВнешнихПользователей",
			ПредопределенноеЗначение("Справочник.ГруппыВнешнихПользователей.ВсеВнешниеПользователи"));
	Иначе
	#Если Сервер Тогда
		Если ЗначениеЗаполнено(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока) Тогда
			ТекущиеДанные = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
				Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока, "ВсеОбъектыАвторизации");
		Иначе
			ТекущиеДанные = Неопределено;
		КонецЕсли;
	#Иначе
		ТекущиеДанные = Элементы.ГруппыВнешнихПользователей.ТекущиеДанные;
	#КонецЕсли
		
		Если ТекущиеДанные <> Неопределено
		   И ТекущиеДанные.ВсеОбъектыАвторизации Тогда
			
			ЭлементПредставленияТипаОбъектаАвторизации =
				Форма.ХранимыеПараметры.ПредставлениеТиповОбъектовАвторизации.НайтиПоЗначению(
					ТекущиеДанные.ТипОбъектовАвторизации);
				
			ОбновитьЗначениеПараметраКомпоновкиДанных(
				Форма.ВнешниеПользователиСписок, "ВыбиратьИерархически", Истина);
		Иначе
			ОбновитьЗначениеПараметраКомпоновкиДанных(
				Форма.ВнешниеПользователиСписок, "ВыбиратьИерархически", Форма.ВыбиратьИерархически);
		КонецЕсли;
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(
			Форма.ВнешниеПользователиСписок,
			"ГруппаВнешнихПользователей",
			Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗначениеПараметраКомпоновкиДанных(Знач ВладелецПараметров,
                                                    Знач ИмяПараметра,
                                                    Знач ЗначениеПараметра)
	
	Для каждого Параметр Из ВладелецПараметров.Параметры.Элементы Цикл
		Если Строка(Параметр.Параметр) = ИмяПараметра Тогда
			
			Если Параметр.Использование
			   И Параметр.Значение = ЗначениеПараметра Тогда
				
				Возврат;
			КонецЕсли;
			Прервать;
			
		КонецЕсли;
	КонецЦикла;
	
	ВладелецПараметров.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Перетаскивание пользователей

&НаКлиенте
Процедура ГруппыВнешнихПользователейПеретаскиваниеОбработкаВопроса(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	СообщениеПользователю = ПеремещениеПользователяВНовуюГруппу(
		ДополнительныеПараметры.ПараметрыПеретаскивания, ДополнительныеПараметры.Строка, ДополнительныеПараметры.Перемещение);
	ГруппыВнешнихПользователейПеретаскиваниеЗавершение(СообщениеПользователю);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейПеретаскиваниеЗавершение(СообщениеПользователю)
	
	Если СообщениеПользователю.Сообщение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("Запись_ГруппыВнешнихПользователей");
	
	Если СообщениеПользователю.ЕстьОшибки = Ложь Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Перемещение пользователей'"), , СообщениеПользователю.Сообщение, БиблиотекаКартинок.Информация32);
	Иначе
		
		Если СообщениеПользователю.Пользователи <> Неопределено Тогда
			Отчет = НСтр("ru = 'Следующие пользователи не были включены в выбранную группу:'");
			Отчет = Отчет + Символы.ПС + СообщениеПользователю.Пользователи;
			
			ТекстВопроса = СообщениеПользователю.Сообщение;
			
			Результат = СтандартныеПодсистемыКлиентСервер.НовыйРезультатВыполнения();
			ВыводПредупреждения = Результат.ВыводПредупреждения;
			ВыводПредупреждения.Использование = Истина;
			ВыводПредупреждения.Текст = ТекстВопроса;
			ВыводПредупреждения.ТекстОшибок = Отчет;
			СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтотОбъект, Результат);
		Иначе
			ПоказатьПредупреждение(,СообщениеПользователю.Сообщение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
