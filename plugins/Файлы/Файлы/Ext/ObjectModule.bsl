﻿/////////////////////////////////////////////////////////////////////
//
// Модуль часто используемых функций работы с файлами
//
// (с) EvilBeaver, 2016
//
/////////////////////////////////////////////////////////////////////

Перем ПутьКФайлуПолный Экспорт;// в эту переменную будет установлен правильный клиентский путь к текущему файлу

Перем КонтекстЯдра;

// { Plugin interface
Функция ОписаниеПлагина(ВозможныеТипыПлагинов) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Тип", ВозможныеТипыПлагинов.Утилита);
	Результат.Вставить("Идентификатор", Метаданные().Имя);
	Результат.Вставить("Представление", "Файлы");
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
КонецФункции

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
КонецПроцедуры
// } Plugin interface

// Функция - Объединить пути
//
// Параметры:
//  Каталог	 - Строка	 - 
//  Файл	 - Строка 	 - 
// 
// Возвращаемое значение:
//  Строка - 
//
Функция ОбъединитьПути(Знач Каталог, Знач Файл) Экспорт
	Если Прав(Каталог, 1) <> ПолучитьРазделительПути() Тогда
		Каталог = Каталог + ПолучитьРазделительПути();
	КонецЕсли; 
	Возврат Каталог + Файл;
КонецФункции // ОбъединитьПути()

// Проверяет существование файла или каталога
//
// Параметры:
//   Путь - Проверяемый путь
//
//  Возвращаемое значение:
//   Булево   - Истина, если файл/каталог существует
//
Функция Существует(Знач Путь) Экспорт
    
    Файл = Новый Файл(Путь);
    
    Возврат Файл.Существует();
    
КонецФункции // Существует()

// Проверяет существование файла
//
// Параметры:
//   Путь - Проверяемый путь
//
//  Возвращаемое значение:
//   Булево   - Истина, если файл существует
//
Функция ФайлСуществует(Знач Путь) Экспорт
    
    Файл = Новый Файл(Путь);
    
    Возврат Файл.Существует() и Файл.ЭтоФайл();
    
КонецФункции // ФайлСуществует()

// Проверяет существование каталога
//
// Параметры:
//   Путь - Проверяемый путь
//
//  Возвращаемое значение:
//   Булево   - Истина, если каталог существует
//
Функция КаталогСуществует(Знач Путь) Экспорт
    
    Файл = Новый Файл(Путь);
    
    Возврат Файл.Существует() и Файл.ЭтоКаталог();
    
КонецФункции // КаталогСуществует()

// Гарантирует наличие пустого каталога с указанным именем
//
// Параметры:
//   Путь - Строка - Путь к каталогу
//
Процедура ОбеспечитьПустойКаталог(Знач Путь) Экспорт
    
    ОбеспечитьКаталог(Путь);
    УдалитьФайлы(Путь, ПолучитьМаскуВсеФайлы());
    
КонецПроцедуры // ОбеспечитьПустойКаталог()

// Гарантирует наличие каталога с указанным именем
//
// Параметры:
//   Путь - Строка - Путь к каталогу
//
Процедура ОбеспечитьКаталог(Знач Путь) Экспорт
    
    Файл = Новый Файл(Путь);
    Если Не Файл.Существует() Тогда
        СоздатьКаталог(Путь);
    ИначеЕсли НЕ Файл.ЭтоКаталог() Тогда
        ВызватьИсключение "Не удается создать каталог " + Путь + ". По данному пути уже существует файл.";
    КонецЕсли;
    
КонецПроцедуры // ОбеспечитьКаталог()

// Гарантирует наличие каталога-родителя для указанного файла или родителя
//
// Параметры:
//  ПутьФайла	 - Строка	 -  Путь к файлу или каталогу
//
Процедура ОбеспечитьКаталогФайла(Знач ПутьФайла) Экспорт

	Файл = Новый Файл(ПутьФайла);
	ОбеспечитьКаталог(Файл.Путь);

КонецПроцедуры

// Копирует все файлы из одного каталога в другой
//
// Параметры:
//   Откуда - Строка - Путь к исходному каталогу
//   Куда - Строка - Путь к каталогу-назначению
//
Процедура КопироватьСодержимоеКаталога(Знач Откуда, Знач Куда) Экспорт

	ОбеспечитьКаталог(Куда);

	Файлы = НайтиФайлы(Откуда, ПолучитьМаскуВсеФайлы());
	Для Каждого Файл Из Файлы Цикл
		ПутьКопирования = ОбъединитьПути(Куда, Файл.Имя);
		Если Файл.ЭтоКаталог() Тогда
			КопироватьСодержимоеКаталога(Файл.ПолноеИмя, ПутьКопирования);
		Иначе
			КопироватьФайл(Файл.ПолноеИмя, ПутьКопирования);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Проверяет является ли каталог пустым.
// Генерирует исключение если каталог с указанным именем не существует.
//
// Параметры:
//   Путь - Строка - Путь к каталогу
//
// Возвращаемое значение:
//   Булево   - Истина, если каталог пуст
//
Функция КаталогПустой(Знач Путь) Экспорт
	
	Если НЕ КаталогСуществует(Путь) Тогда
		ВызватьИсключение "Каталог <" + Путь + "> не существует";
	КонецЕсли;
	
	МассивФайлов = НайтиФайлы(Путь, ПолучитьМаскуВсеФайлы(), Ложь);

	Возврат МассивФайлов.Количество() = 0;

КонецФункции // КаталогПустой(Знач Путь)

// Возвращает путь файла относительно корневого каталога
//
// Параметры:
//   ПутьКорневогоКаталога - Строка - путь корневого каталога
//   ПутьВнутреннегоФайла - Строка - путь файла
//   РазделительПути - Строка или Неопределено - все разделители в пути заменяются на указанный разделитель пути
//		если Неопределено, то разделители пути не заменяются
//
//  Возвращаемое значение:
//   Строка - относительный путь файла
//
Функция ОтносительныйПуть(Знач ПутьКорневогоКаталога, Знач ПутьВнутреннегоФайла, Знач РазделительПути = Неопределено) Экспорт

	Если ПустаяСтрока(ПутьКорневогоКаталога) Тогда	
		ВызватьИсключение "Не указан корневой путь в методе ФС.ОтносительныйПуть";
	КонецЕсли;
	
	ФайлКорень = Новый Файл(ПутьКорневогоКаталога);
	ФайлВнутреннийКаталог = Новый Файл(ПутьВнутреннегоФайла);
	Рез = СтрЗаменить(ФайлВнутреннийКаталог.ПолноеИмя, ФайлКорень.ПолноеИмя, "");
	Если Найти("\/", Лев(Рез, 1)) > 0 Тогда
		Рез = Сред(Рез, 2);
	КонецЕсли;
	Если Найти("\/", Прав(Рез, 1)) > 0 Тогда
		Рез = Лев(Рез, СтрДлина(Рез)-1);
	КонецЕсли;
	Если РазделительПути <> Неопределено Тогда
		Рез = СтрЗаменить(Рез, "\", РазделительПути);
		Рез = СтрЗаменить(Рез, "/", РазделительПути);
	КонецЕсли;

	Если ПустаяСтрока(Рез) Тогда
		Рез = ".";
	КонецЕсли;

	Возврат Рез;
КонецФункции

// Возращает полный путь, приведенный по правилам ОС.
//
// Параметры:
//  ОтносительныйИлиПолныйПуть - Строка - фрагмент или полный путь
//
// Возвращаемое значение:
//   Строка   - путь, оформленный по правилам ОС
//
Функция ПолныйПуть(Знач ОтносительныйИлиПолныйПуть) Экспорт
	Файл = Новый Файл(ОтносительныйИлиПолныйПуть);
	Возврат Файл.ПолноеИмя;
КонецФункции // ПолныйПуть(Знач ОтносительныйИлиПолныйПуть) Экспорт

// Процедура - Записать файл в кодировке UTF-8
//
// Параметры:
//  ПутьФайла	 - Строка	 - 
//  ТекстФайла	 - Строка	 - 
//
Процедура ЗаписатьФайл(Знач ПутьФайла, Знач ТекстФайла) Экспорт
	Запись = Новый ЗаписьТекста(ПутьФайла, КодировкаТекста.UTF8);
	Запись.Записать(ТекстФайла);
	Запись.Закрыть();
КонецПроцедуры

// Функция - Прочитать файл в кодировке UTF-8
//
// Параметры:
//  Путь			 - Строка	 - 
//  МонопольныйРежим - Булево	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция ПрочитатьФайл(Знач Путь, Знач МонопольныйРежим = Истина) Экспорт

	Если МонопольныйРежим Тогда
		Чтение = Новый ЧтениеТекста(Путь, КодировкаТекста.UTF8); //для совместимости
	Иначе
		Чтение = Новый ЧтениеТекста(Путь, КодировкаТекста.UTF8, , МонопольныйРежим);
	КонецЕсли;
	Текст = Чтение.Прочитать();
	Чтение.Закрыть();

	Возврат Текст;

КонецФункции

// Функция - Каталог запускателя тестов
// 
// Возвращаемое значение:
//   Строка - 
//
Функция КаталогЗапускателяТестов() Экспорт
	ФайлЗапускателяТестов = Новый Файл(КонтекстЯдра.ИспользуемоеИмяФайла);
	Возврат ФайлЗапускателяТестов.Путь;
КонецФункции

// Функция - Имя запускателя тестов
// 
// Возвращаемое значение:
//   Строка - 
//
Функция ИмяЗапускателяТестов() Экспорт
	ФайлЗапускателяТестов = Новый Файл(КонтекстЯдра.ИспользуемоеИмяФайла);
	Возврат ФайлЗапускателяТестов.ИмяБезРасширения;
КонецФункции
