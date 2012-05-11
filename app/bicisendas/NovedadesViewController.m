//
//  FirstViewController.m
//  bicisendas
//
//  Created by Ariel Scarpinelli on 10/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NovedadesViewController.h"


@implementation NovedadesViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    //Initialize the array.
    novedades = [[NSMutableArray alloc] init];
    
    //Add items
    [novedades addObject: [[NewsPost alloc] initWithTitle: @"Nuevo límite de tiempo de uso" description:@"A partir del 1º de noviembre habrá modificaciones" url:@"http://mejorenbici.buenosaires.gob.ar/2011/10/17/atencion-usuarios-del-sistema-de-transporte-publico-en-bicicletas/"]];
    
    [novedades addObject: [[NewsPost alloc] initWithTitle: @"Mirá las fotos de la Bicicleteada en la Ciudad" description:@"El domingo 16 de octubre se realizó la bicicleteada mensual." url:@"http://mejorenbici.buenosaires.gob.ar/2011/10/17/mira-las-fotos-de-la-bicicleteada-en-la-ciudad/"]];

    [novedades addObject: [[NewsPost alloc] initWithTitle: @"Concurso: Vos y tu Bici" description:@"Sacá una foto, publicala, y si es la que más votos recibe, podés ser el ganador." url:@"http://mejorenbici.buenosaires.gob.ar/2011/09/27/concurso-vos-y-tu-bici/"]];
    
    [novedades addObject: [[NewsPost alloc] initWithTitle: @"Nuevo Modelo de Bicicleta" description:@"La bicicleta nueva tiene un mecanismo de transmisión más robusto." url:@"http://mejorenbici.buenosaires.gob.ar/2011/08/25/nuevo-modelo-de-bicicleta/"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [novedades count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } 
    
    // Set up the cell...
    NewsPost *post = (NewsPost*) [novedades objectAtIndex:indexPath.row];
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = post.description;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!detailsView) {
        detailsView = [[NewsPostDetailsViewController alloc] initWithNibName:@"NewsPostDetailsViewController" bundle:[NSBundle mainBundle]];
    }
    
    detailsView.newsPost = [novedades objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController: detailsView animated:TRUE];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    [novedades release];
    novedades = nil;
    
    if (detailsView) {
        [detailsView release];
        detailsView = nil;
    }
}


- (void)dealloc
{
    [super dealloc];
}

@end
