  package com.abiquo.server.core.pricing;

  import javax.xml.bind.annotation.XmlRootElement;

  import com.abiquo.model.transport.SingleResourceTransportDto;

  @XmlRootElement(name = "")
  public class CurrencyDto extends SingleResourceTransportDto
  {
      private Integer id;
      public Integer getId()
      {
          return id;
      }

      public void setId(Integer id)
      {
          this.id = id;
      }

      private String name;

public String getName()
{
    return name;
}

public void setName(String name)
{
    this.name = name;
}

private String simbol;

public String getSimbol()
{
    return simbol;
}

public void setSimbol(String simbol)
{
    this.simbol = simbol;
}

  }