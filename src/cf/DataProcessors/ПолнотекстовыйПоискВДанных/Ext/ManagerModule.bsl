﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "Форма" Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ОбщаяФорма.ФормаПоиска";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
