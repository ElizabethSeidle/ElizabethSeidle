# Creating a Network Graphic Visualization 

This project created a network graphic to visualize a group of faculty's collaborations with each other. Data was collected from the faculty themselves (mentoring data), PubMed (publication data), and NIH & NSF APIs (funding data). 

Edges color represents the type of collabortion between two faculty. Node color corresponds to the faculty's position title and tenure. 

## Process Outline
- [Load data of faculty titles and collaborations](Data/)
- [Run data through python code to convert into a Gephi file](Code/TSVtoGEXF.equalweights.ipynb)
- [Format Gephi file to be in desired format](PPPID_2019_gephidoc_curved.gephi)
- [Export final graphic](NetworkGraphic_PPPID_2019_Curved.png)
