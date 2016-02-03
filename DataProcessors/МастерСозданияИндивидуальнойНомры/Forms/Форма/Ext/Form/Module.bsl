﻿//****************************** СОБЫТИЯ ФОРМЫ *******************************

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Пол 						= "М";
	Объект.БеременностьКормление 	= 0;
	Объект.Источник				 	= 1;
	
	Элементы.ГруппаФизАктивности.Доступность 		= Объект.Возраст > 18;  		
	Элементы.ИскусственноеВскармливание.Доступность = Объект.Возраст < 1;
	Элементы.БеременностьКормление.Доступность 		= Объект.Пол = "Ж";
	
	Для каждого Ит Из Метаданные.Перечисления.ТипыНутриентов.ЗначенияПеречисления Цикл
		ЗаполняемыеНутриенты.Добавить(Перечисления.ТипыНутриентов[Ит.Имя]);	
	КонецЦикла; 
	
	ЗаполнитьСпискиЗначенийИменМакетов();  	
	ЗаполнитьДанныеПоказателейИзТабличныхДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОтобразитьТекущиеМакеты(); 
КонецПроцедуры 

//****************************** КОМАНДЫ *******************************
&НаКлиенте
Процедура Назад(Команда)
	
	ТекущийСписок = ИменаМакетовМР231243108;
	
	НавигацияПоМакетам(ТекущийСписок, -1);
	ОтобразитьТекущиеМакеты();
	
КонецПроцедуры 

&НаКлиенте
Процедура Вперед(Команда)
	
	ТекущийСписок = ИменаМакетовМР231243108;
	
	НавигацияПоМакетам(ТекущийСписок, 1);
	ОтобразитьТекущиеМакеты();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанными(Команда)
	
	Отбор		 = Новый Структура("Категория, Возраст, ГруппаФизАктивности, ТипНутриента"); 	
	МассивТипов	 = ЗаполняемыеНутриенты.ВыгрузитьЗначения();
		
	Если Объект.Возраст < 18 Тогда
		Отбор.Категория = Объект.Пол + "П";
	Иначе
		Отбор.Категория = Объект.Пол;
	КонецЕсли; 	
	
	Отбор.ГруппаФизАктивности 	= Объект.ГруппаФизАктивности;
	Отбор.ТипНутриента			= МассивТипов;
	
	Если Объект.Возраст < 0.25 Тогда
		Отбор.Возраст = 4;
		Отбор.ГруппаФизАктивности 	= 0;
	ИначеЕсли Объект.Возраст < 0.5 Тогда
		Отбор.Возраст = 5;
		Отбор.ГруппаФизАктивности 	= 0;
	ИначеЕсли Объект.Возраст < 1 Тогда
		Отбор.Возраст = 6;
		Отбор.ГруппаФизАктивности 	= 0;
	ИначеЕсли Объект.Возраст < 2 Тогда
		Отбор.Возраст = 7;
		Отбор.ГруппаФизАктивности 	= 0;
	ИначеЕсли Объект.Возраст < 3 Тогда
		Отбор.Возраст = 8;
		Отбор.ГруппаФизАктивности 	= 0;
	ИначеЕсли Объект.Возраст < 7 Тогда
		Отбор.Возраст = 9;
		Отбор.ГруппаФизАктивности 	= 0;
	ИначеЕсли Объект.Возраст < 11 Тогда
		Отбор.Возраст = 10;
		Отбор.ГруппаФизАктивности 	= 0;
	ИначеЕсли Объект.Возраст < 14 Тогда
		Отбор.Возраст = 11;
		Отбор.ГруппаФизАктивности 	= 0;
	ИначеЕсли Объект.Возраст < 18 Тогда
		Отбор.Возраст = 12;
		Отбор.ГруппаФизАктивности 	= 0;
	ИначеЕсли Объект.Возраст < 30 Тогда
		Отбор.Возраст = 0;
	ИначеЕсли Объект.Возраст < 40 Тогда
		Отбор.Возраст = 1;
	ИначеЕсли Объект.Возраст < 60 Тогда
		Отбор.Возраст = 2;  		
	ИначеЕсли Объект.Возраст >= 60 Тогда
		Отбор.Возраст 				= 3;
		Отбор.ГруппаФизАктивности 	= 0;
	КонецЕсли;  	
	
	ЗаполнитьДаннымиНаСервере(Отбор);   	
	
КонецПроцедуры   

&НаКлиенте
Процедура СоздатьИндивидуальнуюНорму(Команда)
	СоздатьИндивидуальнуюНормуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыборТиповНутриентов(Команда)
	
	ОткрытьФорму("Обработка.МастерСозданияИндивидуальнойНомры.Форма.ФормаВыбораЗаполняемыхНутриентов", 
								Новый Структура("СписокТиповНутриентов", ЗаполняемыеНутриенты.ВыгрузитьЗначения()), ЭтаФорма);	
	
КонецПроцедуры

//********************************** ОБРАБОТЧИКИ СОБЫТИЙ *******************************
&НаКлиенте
Процедура ИсточникПриИзменении(Элемент)
	
	УстановитьВидимостьСтраницыНастроек();
	
КонецПроцедуры   

&НаКлиенте
Процедура ВозрастПриИзменении(Элемент)
	
	Элементы.ГруппаФизАктивности.Доступность 	= Объект.Возраст > 18;  		
	Элементы.ГруппаДетиДоГода.Доступность 		= Объект.Возраст < 1;
	
	ПриИзмененииПараметровНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолПриИзменении(Элемент)
	
	Элементы.БеременностьКормление.Доступность = Объект.Пол = "Ж" И Объект.Возраст > 8; 
	
	ПриИзмененииПараметровНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииПараметровНаСервере()
	
	
	
КонецПроцедуры  

&НаКлиенте
Процедура НормаПриИзменении(Элемент)
	НормаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура НормаПриИзмененииНаСервере()  	
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НормыПитания.Нутриент,
		|	НормыПитания.Количество,
		|	НормыПитания.МинКоличество,
		|	НормыПитания.МаксКоличество,
		|	НормыПитания.Нутриент.Тип КАК Тип
		|ИЗ
		|	РегистрСведений.НормыПитания КАК НормыПитания
		|ГДЕ
		|	НормыПитания.Норма = &Норма";
	
	Запрос.УстановитьПараметр("Норма", Объект.Норма);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Объект.Показатели.Загрузить(РезультатЗапроса.Выгрузить());  	
	
КонецПроцедуры

//********************************** СЛУЖЕБНОЕ *******************************
&НаКлиенте
Процедура УстановитьВидимостьСтраницыНастроек()
	
	Если Объект.Источник = 1 Тогда
		Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаПараметрыМР231243208;
	Иначе
		Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаПустыхНастроек;	
	КонецЕсли; 
	
КонецПроцедуры   

&НаКлиенте
Процедура ЗаполнитьТипыНутриентов(МассивЗаполнения) Экспорт
	
	ЗаполняемыеНутриенты.ЗагрузитьЗначения(МассивЗаполнения);	
	
КонецПроцедуры
 
&НаСервере
Процедура ЗаполнитьДанныеПоказателейИзТабличныхДокументов()
	
	ЭтаОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	ЭтаОбработкаОбъект.ЗаполнитьПоказателиМужчины_МР231243108();
	ЭтаОбработкаОбъект.ЗаполнитьПоказателиЖенщины_МР231243108();
	ЭтаОбработкаОбъект.ЗаполнитьПоказателиПодростки_МР231243108();
	ЭтаОбработкаОбъект.ЗаполнитьПоказателиДополнительные_МР231243108();
	ЭтаОбработкаОбъект.ЗаполнитьПоказателиБАВ_МР231243108();
	ЭтаОбработкаОбъект.ЗаполнитьПоказателиАминокислотыМЩ();
	
	ЗначениеВРеквизитФормы(ЭтаОбработкаОбъект, "Объект");
	
КонецПроцедуры   

&НаСервере
Процедура СоздатьИндивидуальнуюНормуНаСервере()
	
	Если ТипЗнч(Объект.Норма) = Тип("Строка") Тогда
		НормаОбъект 				= Справочники.НормыНутриентов.СоздатьЭлемент();
		НормаОбъект.Наименование 	= Объект.Норма;
	Иначе	
		НормаОбъект = Объект.Норма.ПолучитьОбъект();		
	КонецЕсли; 
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Вт_Показтели.Нутриент КАК Нутриент,
	                      |	Вт_Показтели.Количество КАК Количество,
	                      |	Вт_Показтели.МинКоличество КАК МинКоличество,
	                      |	Вт_Показтели.МаксКоличество КАК МаксКоличество,
	                      |	Вт_Показтели.Тип КАК Тип
	                      |ПОМЕСТИТЬ Вт_ТекПкз
	                      |ИЗ
	                      |	&ТекущиеПоказатели КАК Вт_Показтели
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Вт_ТекПкз.Нутриент КАК Имя,
	                      |	СУММА(Вт_ТекПкз.Количество) КАК Количество
	                      |ИЗ
	                      |	Вт_ТекПкз КАК Вт_ТекПкз
	                      |ГДЕ
	                      |	(Вт_ТекПкз.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыНутриентов.МакроНутриенты)
	                      |			ИЛИ Вт_ТекПкз.Нутриент = ЗНАЧЕНИЕ(Справочник.Нутриенты.Калорийность))
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Вт_ТекПкз.Нутриент
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	НЕОПРЕДЕЛЕНО КАК Норма,
	                      |	Вт_ТекПкз.Нутриент,
	                      |	СУММА(Вт_ТекПкз.Количество) КАК Количество,
	                      |	СУММА(Вт_ТекПкз.МинКоличество) КАК МинКоличество,
	                      |	СУММА(Вт_ТекПкз.МаксКоличество) КАК МаксКоличество
	                      |ИЗ
	                      |	Вт_ТекПкз КАК Вт_ТекПкз
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Вт_ТекПкз.Нутриент");
						  
	Запрос.УстановитьПараметр("ТекущиеПоказатели", Объект.Показатели.Выгрузить());
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаРеквизитов  = РезультатЗапроса[1].Выбрать();
	ТаблицаПоказателей = РезультатЗапроса[2].Выгрузить();
	
	Пока ВыборкаРеквизитов.Следующий() Цикл
		НормаОбъект[Строка(ВыборкаРеквизитов.Имя)] = ВыборкаРеквизитов.Количество;			
	КонецЦикла; 	
	
	Попытка
		НормаОбъект.Записать();
		Объект.Норма = НормаОбъект.Ссылка;		
	Исключение
	    Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки();
		Сообщение.Сообщить(); 
	КонецПопытки; 

	ТаблицаПоказателей.ЗаполнитьЗначения(НормаОбъект.Ссылка, "Норма");
	
	Набор = РегистрыСведений.НормыПитания.СоздатьНаборЗаписей();
	Набор.Отбор.Норма.Установить(НормаОбъект.Ссылка);
	Набор.Загрузить(ТаблицаПоказателей);
	Набор.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиЗначенийИменМакетов()
	
	Пометка = Истина;
	Для каждого Ит Из Метаданные.Обработки.МастерСозданияИндивидуальнойНомры.Макеты Цикл 		
		
		Если Найти(Ит.Имя, "МР231243108") > 0 Тогда
			ИменаМакетовМР231243108.Добавить(Ит.Имя, Ит.Синоним, Пометка);	
			Пометка = Ложь;
		КонецЕсли; 
		
	КонецЦикла; 	
		
КонецПроцедуры 

&НаСервере
Функция ПолучитьДанныеМакета(ИмяМакета)
	
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	Результат 		= ОбъектОбработки.ПолучитьМакет(ИмяМакета);	
	Возврат Результат;
	
КонецФункции 

&НаКлиенте
Процедура ОтобразитьТекущиеМакеты()

	Для каждого Ит Из ИменаМакетовМР231243108 Цикл
		Если Ит.Пометка Тогда
			ТабличныйДокумент = ПолучитьДанныеМакета(Ит.Значение);
			Если ТабличныйДокумент <> Неопределено Тогда
				ТДМР231243108 						= ТабличныйДокумент;
				Элементы.ТДМР231243108.Заголовок 	= Ит.Представление;
			КонецЕсли; 
			Прервать;
		КонецЕсли; 	
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияПоМакетам(Список, Сдвиг)
	
	КоличествоЭлементов = Список.Количество() - 1;
	ТекущийНомер = 0;
	Для Сч = 0 По КоличествоЭлементов Цикл
		Если Список[Сч].Пометка Тогда
			Список[Сч].Пометка = Ложь;
			ТекущийНомер = Сч;
			Прервать;	
		КонецЕсли; 	
	КонецЦикла;  
	
	НовыйНомер = ТекущийНомер + Сдвиг;
	Если НовыйНомер > КоличествоЭлементов Тогда
		НовыйНомер = 0;  	
	КонецЕсли; 
	
	Если НовыйНомер < 0 Тогда
		НовыйНомер = КоличествоЭлементов;
	КонецЕсли;
	
	ИменаМакетовМР231243108[НовыйНомер].Пометка = Истина; 	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДаннымиНаСервере(Отбор)
	
	МенеджерВТ = ПолучитьВТТекущихПоказателей(Отбор.ТипНутриента);
	
	Если Объект.Источник = 1 Тогда
		ЗаполнитьДаннымиМР231243108НаСервере(МенеджерВТ, Отбор);
	ИначеЕсли Объект.Источник = 2 Тогда 
		ЗаполнитьДаннымиМЩНаСервере(МенеджерВТ, Отбор);
	КонецЕсли; 
	
КонецПроцедуры    

&НаСервере
Процедура ЗаполнитьДаннымиМР231243108НаСервере(МенеджерВТ, ОтборОсновной)
	
	МассивНЗМРГ = Новый Массив; //массив нутриентов, зависящих от массы у ребенка до года
	МассивНЗМРГ.Добавить(Справочники.Нутриенты.Калорийность);
	МассивНЗМРГ.Добавить(Справочники.Нутриенты.Белки);
	МассивНЗМРГ.Добавить(Справочники.Нутриенты.Жиры);
	МассивНЗМРГ.Добавить(Справочники.Нутриенты.Углеводы);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Данные.Категория КАК Категория,
	               |	Данные.Возраст КАК Возраст,
	               |	Данные.ГруппаФизАктивности КАК ГруппаФизАктивности,
	               |	Данные.Нутриент КАК Нутриент,
	               |	Данные.Количество КАК Количество,
	               |	Данные.ТипНутриента КАК ТипНутриента,
	               |	Данные.МинКоличество КАК МинКоличество,
	               |	Данные.МаксКоличество КАК МаксКоличество,
	               |	ВЫБОР
	               |		КОГДА Данные.Возраст > 3
	               |				И Данные.Возраст < 7
	               |				И Данные.Нутриент В (&МассивНЗМРГ)
	               |			ТОГДА ВЫБОР
	               |					КОГДА &ИВ = ИСТИНА
	               |						ТОГДА &Масса
	               |					ИНАЧЕ 0
	               |				КОНЕЦ
	               |		ИНАЧЕ 1
	               |	КОНЕЦ КАК ИВ,
	               |	ВЫБОР
	               |		КОГДА &УКС = ИСТИНА
	               |				И Данные.Возраст < 4
	               |			ТОГДА 1.15
	               |		ИНАЧЕ 1
	               |	КОНЕЦ КАК УКС
	               |ПОМЕСТИТЬ Вт_Данные
	               |ИЗ
	               |	&Данные КАК Данные
	               |ГДЕ
	               |	Данные.ТипНутриента В(&ТипНутриента)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Вт_Данные.Нутриент,
	               |	Вт_Данные.Количество * Вт_Данные.УКС * Вт_Данные.ИВ КАК Количество,
	               |	Вт_Данные.МинКоличество * Вт_Данные.УКС * Вт_Данные.ИВ КАК МинКоличество,
	               |	Вт_Данные.МаксКоличество * Вт_Данные.УКС * Вт_Данные.ИВ КАК МаксКоличество,
	               |	Вт_Данные.ТипНутриента КАК Тип
	               |ПОМЕСТИТЬ Вт_Рассчитанные
	               |ИЗ
	               |	Вт_Данные КАК Вт_Данные
	               |ГДЕ
	               |	Вт_Данные.Категория = &Категория
	               |	И Вт_Данные.Возраст = &Возраст
	               |	И Вт_Данные.ГруппаФизАктивности = &ГруппаФизАктивности
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВложенныйЗапрос.Нутриент КАК Нутриент,
	               |	ВложенныйЗапрос.Количество,
	               |	ВложенныйЗапрос.МинКоличество,
	               |	ВложенныйЗапрос.МаксКоличество,
	               |	ВложенныйЗапрос.Тип КАК Тип
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ВложенныйЗапрос.Нутриент КАК Нутриент,
	               |		ВложенныйЗапрос.Количество КАК Количество,
	               |		ВложенныйЗапрос.МинКоличество КАК МинКоличество,
	               |		ВложенныйЗапрос.МаксКоличество КАК МаксКоличество,
	               |		ВложенныйЗапрос.Тип КАК Тип
	               |	ИЗ
	               |		(ВЫБРАТЬ
	               |			Вт_Данные.Нутриент КАК Нутриент,
	               |			Вт_Данные.Количество КАК Количество,
	               |			Вт_Данные.МинКоличество КАК МинКоличество,
	               |			Вт_Данные.МаксКоличество КАК МаксКоличество,
	               |			Вт_Данные.Тип КАК Тип
	               |		ИЗ
	               |			Вт_Рассчитанные КАК Вт_Данные
	               |		
	               |		ОБЪЕДИНИТЬ ВСЕ
	               |		
	               |		ВЫБРАТЬ
	               |			Вт_Данные.Нутриент,
	               |			Вт_Данные.Количество,
	               |			Вт_Данные.МинКоличество,
	               |			Вт_Данные.МаксКоличество,
	               |			Вт_Данные.ТипНутриента
	               |		ИЗ
	               |			Вт_Данные КАК Вт_Данные
	               |		ГДЕ
	               |			Вт_Данные.Категория = ""БК""
	               |			И Вт_Данные.ГруппаФизАктивности = &БеременностьКормление) КАК ВложенныйЗапрос
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		Вт_ТекПкз.Нутриент,
	               |		Вт_ТекПкз.Количество,
	               |		Вт_ТекПкз.МинКоличество,
	               |		Вт_ТекПкз.МаксКоличество,
	               |		Вт_ТекПкз.Тип
	               |	ИЗ
	               |		Вт_ТекПкз КАК Вт_ТекПкз) КАК ВложенныйЗапрос
	               |ГДЕ
	               |	(ВложенныйЗапрос.Количество > 0
	               |			ИЛИ ВложенныйЗапрос.МаксКоличество > 0)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Тип,
	               |	Нутриент";	
				   
	Для каждого Ит Из ОтборОсновной Цикл
		Запрос.УстановитьПараметр(Ит.Ключ, Ит.Значение);		
	КонецЦикла; 
	
	Запрос.УстановитьПараметр("Данные", Объект.ТаблицаДанныхПоказателейМР231243108.Выгрузить());  	
	Запрос.УстановитьПараметр("БеременностьКормление", Объект.БеременностьКормление);
	Запрос.УстановитьПараметр("УКС", Объект.УсловияКрайнегоСевера);
	Запрос.УстановитьПараметр("ИВ", Объект.ИскусственноеВскармливание);	
	Запрос.УстановитьПараметр("Масса", Объект.Масса);
	Запрос.УстановитьПараметр("МассивНЗМРГ", МассивНЗМРГ); 
	
	РезультатЗапроса = Запрос.Выполнить();
	Объект.Показатели.Загрузить(РезультатЗапроса.Выгрузить());	
	
КонецПроцедуры  

&НаСервере
Процедура ЗаполнитьДаннымиМЩНаСервере(МенеджерВТ, Отбор)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Данные.Нутриент КАК Нутриент,
	               |	Данные.Количество КАК Количество,
	               |	Данные.ТипНутриента КАК ТипНутриента,
	               |	Данные.МинКоличество КАК МинКоличество,
	               |	Данные.МаксКоличество КАК МаксКоличество
	               |ПОМЕСТИТЬ Вт_Данные
	               |ИЗ
	               |	&Данные КАК Данные
	               |ГДЕ
	               |	Данные.ТипНутриента В(&ТипНутриента)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВложенныйЗапрос.Нутриент КАК Нутриент,
	               |	ВложенныйЗапрос.Количество,
	               |	ВложенныйЗапрос.ТипНутриента КАК ТипНутриента,
	               |	ВложенныйЗапрос.МинКоличество,
	               |	ВложенныйЗапрос.МаксКоличество
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		Вт_Данные.Нутриент КАК Нутриент,
	               |		Вт_Данные.Количество КАК Количество,
	               |		Вт_Данные.ТипНутриента КАК ТипНутриента,
	               |		Вт_Данные.МинКоличество КАК МинКоличество,
	               |		Вт_Данные.МаксКоличество КАК МаксКоличество
	               |	ИЗ
	               |		Вт_Данные КАК Вт_Данные
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		Вт_ТекПкз.Нутриент,
	               |		Вт_ТекПкз.Количество,
	               |		Вт_ТекПкз.Тип,
	               |		Вт_ТекПкз.МинКоличество,
	               |		Вт_ТекПкз.МаксКоличество
	               |	ИЗ
	               |		Вт_ТекПкз КАК Вт_ТекПкз) КАК ВложенныйЗапрос
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ТипНутриента,
	               |	Нутриент"; 	               

	
	Запрос.УстановитьПараметр("Данные", Объект.ТаблицаДанныхПоказателейМЩ.Выгрузить());	
	Запрос.УстановитьПараметр("ТипНутриента", Отбор.ТипНутриента);
	
	РезультатЗапроса = Запрос.Выполнить();
	Объект.Показатели.Загрузить(РезультатЗапроса.Выгрузить());	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВТТекущихПоказателей(ТипыНутриентов)
	
	Результат = Новый МенеджерВременныхТаблиц;  
			
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Результат;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Вт_Показтели.Нутриент КАК Нутриент,
		|	Вт_Показтели.Количество КАК Количество,
		|	Вт_Показтели.МинКоличество КАК МинКоличество,
		|	Вт_Показтели.МаксКоличество КАК МаксКоличество,
		|	Вт_Показтели.Тип КАК Тип
		|ПОМЕСТИТЬ Вт_ТекПкз
		|ИЗ
		|	&ТекущиеПоказатели КАК Вт_Показтели
		|ГДЕ
		|	НЕ Вт_Показтели.Тип В (&ТипНутриента)";
		
	Запрос.УстановитьПараметр("ТекущиеПоказатели", Объект.Показатели.Выгрузить());	
	Запрос.УстановитьПараметр("ТипНутриента", ТипыНутриентов);	
	РезультатЗапроса = Запрос.Выполнить();   	 
	
	Возврат Результат;
	
КонецФункции

 
 
   
