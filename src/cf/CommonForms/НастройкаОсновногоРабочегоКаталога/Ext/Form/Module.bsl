﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		Элементы.СейчасВЛокальномКэшеФайлов.Видимость = Ложь;
		Элементы.ОчиститьРабочийКаталог.Видимость = Ложь;
	КонецЕсли;
	
	ЗаполнитьПараметрыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ФайловыеФункцииСлужебныйКлиент.РасширениеРаботыСФайламиПодключено() Тогда
		ПодключитьОбработчикОжидания("ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСФайлами", 0.1, Истина);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	РабочийКаталогПользователя = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
	
	ОбновитьТекущееСостояниеРабочегоКаталога();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РабочийКаталогПользователяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ФайловыеФункцииСлужебныйКлиент.РасширениеРаботыСФайламиПодключено() Тогда
		Возврат;
	КонецЕсли;
	
	// Выбираем другой путь к рабочему каталогу.
	ИмяКаталога = РабочийКаталогПользователя;
	Заголовок = НСтр("ru = 'Выберите основной рабочий каталог'");
	Если Не РаботаСФайламиСлужебныйКлиент.ВыбратьПутьКРабочемуКаталогу(ИмяКаталога, Заголовок, Ложь) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьНовыйРабочийКаталог(ИмяКаталога);
	
КонецПроцедуры

&НаКлиенте
Процедура МаксимальныйРазмерЛокальногоКэшаФайловПриИзменении(Элемент)
	
	СохранитьПараметры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждатьПриУдаленииИзЛокальногоКэшаФайловПриИзменении(Элемент)
	
	СохранитьПараметры();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактированияПриИзменении(Элемент)
	
	СохранитьПараметры();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСФайлами()
	
	ФайловыеФункцииСлужебныйКлиент.ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСФайлами(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловВыполнить()
	
	ОткрытьФорму("Справочник.Файлы.Форма.ФайлыВОсновномРабочемКаталоге", , ЭтотОбъект,,,,
		Новый ОписаниеОповещения("СписокФайловЗакрытие", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЛокальныйКэшФайлов(Команда)
	
	ТекстВопроса =
		НСтр("ru = 'Из основного рабочего каталога будут удалены все файлы,
		           |кроме занятых вами для редактирования.
		           |
		           |Продолжить?'");
	Обработчик = Новый ОписаниеОповещения("ОчиститьЛокальныйКэшФайловПослеОтветаНаВопросПродолжить", ЭтотОбъект);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКРабочемуКаталогуПоУмолчанию(Команда)
	
	УстановитьНовыйРабочийКаталог(ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьПараметры()
	
	МассивСтруктур = Новый Массив;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект",    "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "ПутьКЛокальномуКэшуФайлов");
	Элемент.Вставить("Значение",  РабочийКаталогПользователя);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "МаксимальныйРазмерЛокальногоКэшаФайлов");
	Элемент.Вставить("Значение", МаксимальныйРазмерЛокальногоКэшаФайлов * 1048576);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования");
	Элемент.Вставить("Значение", УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов");
	Элемент.Вставить("Значение", ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов);
	МассивСтруктур.Добавить(Элемент);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассивИОбновитьПовторноИспользуемыеЗначения(
		МассивСтруктур);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЛокальныйКэшФайловПослеОтветаНаВопросПродолжить(Ответ, ПараметрыВыполнения) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Выполняется очистка основного рабочего каталога...
	                     |Пожалуйста, подождите.'"));
	
	Обработчик = Новый ОписаниеОповещения("ОчиститьЛокальныйКэшФайловЗавершение", ЭтотОбъект);
	// ОчищатьВсе = Истина.
	РаботаСФайламиСлужебныйКлиент.ОчиститьРабочийКаталог(Обработчик, РазмерФайловВРабочемКаталоге, 0, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЛокальныйКэшФайловЗавершение(Результат, ПараметрыВыполнения) Экспорт
	
	ОбновитьТекущееСостояниеРабочегоКаталога();
	
	Состояние(НСтр("ru = 'Очистка основного рабочего каталога успешно завершена.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловЗакрытие(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьТекущееСостояниеРабочегоКаталога();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыНаСервере()
	
	УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ЛокальныйКэшФайлов", "УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования");
	
	Если УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования = Неопределено Тогда
		УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования = Ложь;
	КонецЕсли;
	
	ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ЛокальныйКэшФайлов", "ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов");
	
	Если ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов = Неопределено Тогда
		ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов = Ложь;
	КонецЕсли;
	
	МаксРазмер = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ЛокальныйКэшФайлов", "МаксимальныйРазмерЛокальногоКэшаФайлов");
	
	Если МаксРазмер = Неопределено Тогда
		МаксРазмер = 100*1024*1024; // 100 мб
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"ЛокальныйКэшФайлов", "МаксимальныйРазмерЛокальногоКэшаФайлов", МаксРазмер);
	КонецЕсли;
	МаксимальныйРазмерЛокальногоКэшаФайлов = МаксРазмер / 1048576;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекущееСостояниеРабочегоКаталога()
	
#Если НЕ ВебКлиент Тогда
	МассивФайлов = НайтиФайлы(РабочийКаталогПользователя, "*.*");
	РазмерФайловВРабочемКаталоге = 0;
	КоличествоСуммарное = 0;
	
	ФайловыеФункцииСлужебныйКлиент.ОбходФайловРазмер(
		РабочийКаталогПользователя,
		МассивФайлов,
		РазмерФайловВРабочемКаталоге,
		КоличествоСуммарное); 
	
	РазмерФайловВРабочемКаталоге = РазмерФайловВРабочемКаталоге / 1048576;
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНовыйРабочийКаталог(НовыйКаталог)
	
	Если НовыйКаталог = РабочийКаталогПользователя Тогда
		Возврат;
	КонецЕсли;
	
#Если Не ВебКлиент Тогда
	Обработчик = Новый ОписаниеОповещения(
		"УстановитьНовыйРабочийКаталогЗавершение", ЭтотОбъект, НовыйКаталог);
	
	РаботаСФайламиСлужебныйКлиент.ПеренестиСодержимоеРабочегоКаталога(
		Обработчик, РабочийКаталогПользователя, НовыйКаталог);
#Иначе
	УстановитьНовыйРабочийКаталогЗавершение(-1, НовыйКаталог);
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНовыйРабочийКаталогЗавершение(Результат, НовыйКаталог) Экспорт
	
	Если Результат <> -1 Тогда
		Если Результат <> Истина Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	РабочийКаталогПользователя = НовыйКаталог;
	
	СохранитьПараметры();
	
КонецПроцедуры

#КонецОбласти
