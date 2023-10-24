#import "../../utils.typ": *

#section("Man in the Middle Attack")

#subsection("DLL Preloading Attack")
The idea is to put a dll in the same folder as the program that is being run,
this means that windows will automatically load the new dll, which might just be
malicious. With the SetDLLPath("") you can disable this behavior.
