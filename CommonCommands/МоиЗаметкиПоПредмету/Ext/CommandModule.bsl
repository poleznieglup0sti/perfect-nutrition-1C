﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	 ПараметрыФормы = Новый Структура("Предмет", ПараметрКоманды);
	 ОткрытьФорму("Справочник.Заметки.Форма.ЗаметкиПоПредмету", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

#КонецОбласти
