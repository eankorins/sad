using System;
using System.Runtime.CompilerServices;
using System.Collections.Generic;
public class StableMarriage 
{
	static void Main()
	{
		Console.WriteLine("Hello World");
		Console.ReadLine();
	}
}

public class Person
{
	public int Number { get; set; }
	public string Name { get; set; }
	public Person Fiance { get; set; }
	public List<Person> PreferenceList { get;set; }
	public List<Person> Proposals { get; set; }


	public override string  ToString()
	{
		return Name;
	}

	public void Display()
	{
		Console.WriteLine("{0} - {1} - {2}", Number, Name, PreferenceList.Select(i => i.Number).Join(","));
	}

	public bool IsSingle()
	{
		return Fiance == null;
	}

	public void BreakUp()
	{
		Fiance = null;
	}

	public void Engage(Person p)
	{
		this.Fiance = p;
		p.Fiance = this;
	}

	public bool IsUpgrade(Person person)
	{
		return PreferenceList.IndexOf(person) < PreferenceList.IndexOf(Fiance);
	}


}