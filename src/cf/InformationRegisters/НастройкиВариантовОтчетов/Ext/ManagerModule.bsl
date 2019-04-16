﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Записывает таблицу настроек в данные регистра по указанным измерениям.
Процедура ЗаписатьПакетНастроек(ТаблицаНастроек, Измерения, Ресурсы, УдалятьСтарые) Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	Для Каждого КлючИЗначение Из Измерения Цикл
		НаборЗаписей.Отбор[КлючИЗначение.Ключ].Установить(КлючИЗначение.Значение, Истина);
		ТаблицаНастроек.Колонки.Добавить(КлючИЗначение.Ключ);
		ТаблицаНастроек.ЗаполнитьЗначения(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	Для Каждого КлючИЗначение Из Ресурсы Цикл
		ТаблицаНастроек.Колонки.Добавить(КлючИЗначение.Ключ);
		ТаблицаНастроек.ЗаполнитьЗначения(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	Если Не УдалятьСтарые Тогда
		НаборЗаписей.Прочитать();
		СтарыеЗаписи = НаборЗаписей.Выгрузить();
		ПоискПоИзмерениям = Новый Структура("Пользователь, Подсистема, Вариант");
		Для Каждого СтараяЗапись Из СтарыеЗаписи Цикл
			ЗаполнитьЗначенияСвойств(ПоискПоИзмерениям, СтараяЗапись);
			Если ТаблицаНастроек.НайтиСтроки(ПоискПоИзмерениям).Количество() = 0 Тогда
				ЗаполнитьЗначенияСвойств(ТаблицаНастроек.Добавить(), СтараяЗапись);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	НаборЗаписей.Загрузить(ТаблицаНастроек);
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

// Очищает настройки по варианту отчета.
Процедура СброситьНастройки(ВариантСсылка = Неопределено) Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	Если ВариантСсылка <> Неопределено Тогда
		НаборЗаписей.Отбор.Вариант.Установить(ВариантСсылка, Истина);
	КонецЕсли;
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

// Очищает настройки указанного (или текущего) пользователя в разделе.
Процедура СброситьНастройкиПользователяВРазделе(РазделСсылка, Пользователь = Неопределено) Экспорт
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("РазделСсылка", РазделСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ИОМ.Ссылка
	|ИЗ
	|	Справочник.ИдентификаторыОбъектовМетаданных КАК ИОМ
	|ГДЕ
	|	ИОМ.Ссылка В ИЕРАРХИИ(&РазделСсылка)";
	МассивПодсистем = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь, Истина);
	Для Каждого ПодсистемаСсылка Из МассивПодсистем Цикл
		НаборЗаписей.Отбор.Подсистема.Установить(ПодсистемаСсылка, Истина);
		НаборЗаписей.Записать(Истина);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецЕсли