var EditorCoupons = React.createClass({
    render: function() {
        return (

            <div className="editor-tool editor-panel-left-nav" id="editor-tool-coupons" >
                <ul className="editor-aside editor-aside-nav">
                    <li><div className="editor-aside-nav-desc"><h3>FALL2016 </h3><p>10% off </p></div></li>
                    <a href="#" className="edit-aside-nav-add"><h4>+ Add New Coupon Type</h4> </a>
                </ul>
                <div className="editor-panel">    
                    <h1>FALL2016</h1>
                    <form>
                        <div className="input-group">
                            <label> Ticket Name</label>
                            <input type="text" />
                        </div>
                        <div className="input-group">
                            <button className="btn btn-primary">Update</button>
                        </div>
                    </form>
                </div>
                <div className="editor-panel empty hidden">
                    <i className="icon icon-tag"> </i>
                    <h1>Coupons</h1>
                    <p>Add a new coupon.</p>
                    <p><button className="btn btn-primary">Add coupon</button> </p>
                </div>                  
            </div>
        )
    } 
});