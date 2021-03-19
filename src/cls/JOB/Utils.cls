/// Simple utility class for running a bunch of SQL commands
Class JOB.Utils
{

ClassMethod Setup(path As %String, verbose As %Boolean = 1) As %Status
{
    set sc = $$$OK
    try {
        set sep = $s($$$isWINDOWS:"\",1:"/")
        set:$e(path,*)'=sep path = path_sep

        write:verbose !,"Setting up from base path '",path,"'",!

        // clean up first
        do ..RunMultiDDL(path_"src"_sep_"ddl"_sep_"drop.sql",, 1, verbose)

        // CREATE TABLE statements
        set sc = ..RunDDLDir(path_"src"_sep_"ddl"_sep_"create",, 0, verbose)
        quit:$$$ISERR(sc)

        // LOAD DATA statements
        set replace("DATA_DIR") = path_"data"_sep
        set sc = ..RunDDLDir(path_"src"_sep_"ddl"_sep_"load", .replace, 1, verbose)
        quit:$$$ISERR(sc)

    } catch (ex) {
        set sc = ex.AsStatus()
    }
    if $$$ISOK(sc) {
        write:verbose !!,"Setup completed successfully",!
    } else {
        write:verbose !!,"Setup failed",!
    }
    quit sc
}

ClassMethod RunSingleDDL(file As %String, ByRef replace As %String, verbose As %Boolean = 1) As %Status
{
    set sc = $$$OK
    try {
        set sep = $s($$$isWINDOWS:"\",1:"/")
        
        write:verbose !,"Running DDL statement from file '",$piece(file,sep,*),"'"
        
        set stream = ##class(%Stream.FileCharacter).%New()
        set sc = stream.LinkToFile(file)
        quit:$$$ISERR(sc)

        write:verbose !,"  Executing: "

        set sql = 0
        while 'stream.AtEnd {
            set line = $zstrip(stream.ReadLine(),"<>WC")
            continue:line=""

            set str = ""
            for {
                set str = $order(replace(str),1,rep)
                quit:str=""
                set line = $replace(line,"${"_str_"}",rep)
            }

            write:verbose !,"      ",line

            continue:$e(line,1,2)="--" // skip comment lines

            set sql = sql+1, 
                sql(sql) = line
        }
    
        set rs = ##class(%SQL.Statement).%ExecDirect(,.sql)
        if rs.%SQLCODE {
            write:verbose !,"    failed: ",rs.%Message,!
            set sc = $$$ERROR($$$GeneralError, "Error running statement: "_rs.%Message)
        } else {
            write:verbose !,"    success",!
        }

    } catch (ex) {
        set sc = ex.AsStatus()
        write:verbose !,"Unexpected error: ",$system.Status.GetOneErrorText(sc)
    }
    quit sc
}

ClassMethod RunMultiDDL(file As %String, ByRef replace As %String, ignoreErrors As %Boolean = 0, verbose As %Boolean = 1) As %Status
{
    set sc = $$$OK
    try {
        set sep = $s($$$isWINDOWS:"\",1:"/")
        
        write:verbose !,"Running DDL statements from file '",$piece(file,sep,*),"'"

        set stream = ##class(%Stream.FileCharacter).%New()
        set sc = stream.LinkToFile(file)
        quit:$$$ISERR(sc)

        while 'stream.AtEnd {
            set line = $zstrip(stream.ReadLine(),"<>WC")
            continue:line=""

            set str = ""
            for {
                set str = $order(replace(str),1,rep)
                quit:str=""
                set line = $replace(line,"${"_str_"}",rep)
            }

            continue:$e(line,1,2)="--" // skip comment lines

            write:verbose !,"  Executing: ",line
            set rs = ##class(%SQL.Statement).%ExecDirect(,line)
            if rs.%SQLCODE {
                write:verbose !,"    failed: ",rs.%Message
                if 'ignoreErrors {
                    set sc = $$$ERROR($$$GeneralError, "Error running statement: "_rs.%Message)
                    quit
                }
            } else {
                write:verbose !,"    success"
            }
        }
        
    } catch (ex) {
        set sc = ex.AsStatus()
        write:verbose !,"Unexpected error: ",$system.Status.GetOneErrorText(sc)
    }
    quit sc
}

ClassMethod RunDDLDir(directory As %String, ByRef replace As %String, ignoreErrors As %Boolean = 0, verbose As %Boolean = 1) As %Status
{
    set sc = $$$OK
    try {
        write:verbose !!,"Running all DDL in directory '",directory,"'",!

        set rs = ##class(%ResultSet).%New("%File:FileSet")
        do rs.%Execute(directory, "*.sql")
        while rs.%Next() {
            set sc = ..RunSingleDDL(rs.%Get("Name"), .replace, verbose)
            quit:$$$ISERR(sc)&&'ignoreErrors
        }
        
    } catch (ex) {
        set sc = ex.AsStatus()
    }
    quit sc
}

}
