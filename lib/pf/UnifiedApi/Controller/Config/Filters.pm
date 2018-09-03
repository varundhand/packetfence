package pf::UnifiedApi::Controller::Config::Filters;

=head1 NAME

pf::UnifiedApi::Controller::Config::Filters - 

=cut

=head1 DESCRIPTION

pf::UnifiedApi::Controller::Config::Filters



=cut

use strict;
use warnings;
use pf::constants::filters qw(%CONFIGSTORE_MAP);
use File::Slurp;
use pf::util;
use pf::error qw(is_error);
use Mojo::Base qw(pf::UnifiedApi::Controller::RestRoute);

=head2 resource

Validate the resource

=cut

sub resource {
    my ($self) = @_;
    my $id = $self->stash->{filter_id};
    unless (exists $CONFIGSTORE_MAP{"${id}-filters"}) {
        return $self->render_error("404", "Item ($id) not found");
    }

    return 1;
}

=head2 fileName

File Name of filter

=cut

sub fileName {
    my ($self) = @_;
    return $self->configStore->configFile;
}

=head2 configStore

configStore

=cut

sub configStore {
    my ($self) = @_;
    my $id = $self->stash->{filter_id};
    return $CONFIGSTORE_MAP{"${id}-filters"};
}

=head2 get

get the content of the filter

=cut

sub get {
    my ($self) = @_;
    my $fileName = $self->fileName;
    return $self->render(text => scalar read_file($fileName), status => 200);
}

=head2 replace

replace on filter content

=cut

sub replace {
    my ($self) = @_;
    my $id = $self->stash->{filter_id};
    my ($status, $msg)  = $self->is_valid();
    if (is_error($status)) {
        return $self->render_error(422, $msg);
    }
    pf::util::safe_file_update($self->fileName, $self->req->body);
    return $self->render(status => $status, json => {status => "success"});
}

=head2 is_valid

is_valid

=cut

sub is_valid {
    my ($self) = @_;
    return (200, undef);
}

=head1 AUTHOR

Inverse inc. <info@inverse.ca>

=head1 COPYRIGHT

Copyright (C) 2005-2018 Inverse inc.

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
USA.

=cut

1;

