*** Settings ***
Documentation     Test with SOAP (WSDL) with two parameters that returns the country passing the IP
Resource  ./Resources/DataManager.robot
Library  SudsLibrary
Library  XML
Library  RequestsLibrary
Library  OperatingSystem
Library  String

*** Variables ***
${ip} =  195.138.193.207
${int_a} =  2
${int_b} =  3
${FilePath} =  ./CsvData/data.csv

*** Test Cases ***
ConsultaIP
    Create Soap Client    http://ws.cdyne.com/ip2geo/ip2geo.asmx?wsdl
    ${result}    Call Soap Method    ResolveIP    ${ip}    null
    ${country}    Get Wsdl Object Attribute    ${result}    Country
    ${Latitude}    Get Wsdl Object Attribute    ${result}    Latitude
    ${Longitude}    Get Wsdl Object Attribute    ${result}    Longitude
    log    The IP ${ip} belongs to the country ${country}, Latitude: ${Latitude} Longitude: ${Longitude}

Calculator Add
    Create Soap Client    http://www.dneonline.com/calculator.asmx?wsdl
    ${result_add}    Call Soap Method    Add    ${int_a}    ${int_b}
    ${int_c} =    Evaluate    ${int_a}+${int_b}
    log  ${int_a} + ${int_b} = ${result_add}
    Should Be Equal  ${int_c}  ${result_add}

Calculator Subtract
    Create Soap Client    http://www.dneonline.com/calculator.asmx?wsdl
    ${result_sub}    Call Soap Method    Subtract    ${int_a}    ${int_b}
    ${int_c} =    Evaluate    ${int_a}-${int_b}
    log  ${int_a} - ${int_b} = ${result_sub}
    Should Be Equal  ${int_c}  ${result_sub}

DataDriven CalcAdd
    ${Data} =  read csv file  ${FilePath}
    Log  ${Data}
    Create Soap Client    http://www.dneonline.com/calculator.asmx?wsdl
    :FOR  ${vars}  IN  @{Data}
    \  ${result_add}    Call Soap Method    Add    ${vars[0]}    ${vars[1]}
    \  ${int_c} =    Evaluate    ${vars[0]}+${vars[1]}
    \  run keyword and continue on failure  Should Be Equal  ${int_c}  ${result_add}
    \  ${result} =          Convert to string    ${result_add}
    \  run keyword and continue on failure  Should Be Equal  ${vars[2]}  ${result}
