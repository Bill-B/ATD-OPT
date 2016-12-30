%% writeXML
%make an xml file from a matlab xml structure created using parseXML.m
function makeXML(theStruct,xmlname)
row = 1;
if  isempty(theStruct(1).Attributes)
    row = 2;
end

docNode = com.mathworks.xml.XMLUtils.createDocument(theStruct(row).Name);
mainnode = docNode.getDocumentElement;

makeAttributes(mainnode,docNode,theStruct(row).Attributes);
makeChildren(mainnode,docNode,theStruct(row).Children);

xmlwrite(xmlname,docNode);
%% END OF MAIN

%% LOCAL FUNCTIONS %%

%% MAKE ATTRIBUTES
    function makeAttributes(node,docNode,attributes)
        for a = 1:size(attributes,2)
            node.setAttribute(attributes(a).Name,attributes(a).Value);
        end
        clear a
    end

%% MAKE CHILDREN
    function makeChildren(thiselement,docNode,children)
        for c = 1:size(children,2)
            switch children(c).Name
                case '#text'
                    thiselement.appendChild(docNode.createTextNode(children(c).Data));
                case '#comment'
                    thiselement.appendChild(docNode.createComment(children(c).Data));
                otherwise %create a new element node to append to thiselement
                    newelement = docNode.createElement(children(c).Name);
                    if isempty(children(c).Attributes)==0
                        makeAttributes(newelement,docNode,children(c).Attributes)
                    end
                    if isempty(children(c).Children)==0
                        makeChildren(newelement,docNode,children(c).Children) %yeah, this function calls itself...
                    end
                    thiselement.appendChild(newelement);
            end
            
        end
    end
end